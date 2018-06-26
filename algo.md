## Алгоритм работы системы тарификации краткосрочной аренды автомобиля:

Изначально предполагаем, что пользователь подтвержден, данные, в том числе права, указаны корректно, договор заключен.

От мобильного приложения поступает запрос на аренду автомобиля. В нем указан car_id, user_id.
Если они отсутствуют в запросе - выдаем сообщение об ошибке.
Делаем select из таблицы user по user_id, а также подтягиваем связанные данные о группе пользователя. Если
пользователь не найден - уведомление об ошибке.

Далее по car_id делаем select из таблицы car, а также подтягиваем связанные данные о модели автомобиля (car_model) по car_model_id_fk,
данные о классе автомобиля (car_class) по car_class_id_fk, данные о тарифе (car_rent_tariff) по car_rent_tariff_class_id_fk.
Если не удается найти авто или связанные данные отсутствуют - сообщение об ошибке.

Если на счету пользователя денег меньше, чем некоторое пороговое значение для тарифа автомобиля и тарифа, 
то при попытке забронировать автомобиль выдается предупреждение, что для аренда данного авто недостаточно денег.
Если денег на балансе достаточно, то отдаем данные о тарифе мобильному приложению.

Возможные статусы у автомобиля - reserve, inspect, on_trip, park, free, on_repair (бронь, осмотр, поездка, парковка, свободен, на ремонте).

###Этап бронирования

При запросе о начале бронирования, создаем новую запись в таблице car_rent со статусом reserve и в таблице car у соответствующего
автомобиля устанавливаем status=reserve, фиксируем время начала бронирования reserve_begin_dt и подтверждаем аренду.
При переходе аренды к этапу осмотра, фиксируем время завершения бронирования reserve_end_dt и 
рассчитываем стоимость этапа бронирования в reserve_price:
Если время начала и время окончания целиком попадают в интервал [reserve_free_time_start; reserve_free_time_end], 
то стоимость - 0.
Если целиком вне интервала, то reserve_price_time = reserve_free_time_end - reserve_free_time_start.
Иначе reserve_price_time = (reserve_free_time_start - reserve_begin_dt) + (reserve_end_dt - reserve_free_time_end).
Если reserve_price_time > reserve_free_period, то умножаем разницу на стоимость минуты бронирования в тарифе:
reserve_price = (reserve_price_time - reserve_free_period) * reserve_minute_price, иначе reserve_price = 0.
Если полученная reserve_price > 0, то последовательно смотрим:
  - если установлен в 1 user_privilege_koef_is у car_tariff, то reserve_price умножаем на privilege_koef у user;
  - если установлен в 1 user_group_koef_is у car_tariff, то reserve_price умножаем на group_koef у user_group;
  - если установлен в 1 car_class_koef_is у car_tariff, то reserve_price умножаем на class_koef у car_class.
Записываем стоимость этапа бронирования в reserve_price у car_rent. 

###Осмотр

На этапе осмотра фиксируем время начала inspect_begin_dt и завершения inspect_end_dt.
Если разница inspect_end_dt - inspect_begin_dt > inspect_free_period у тарифа, 
то приводим к минутам разницу и умножаем на стоимость минуты:
inspect_price  = (minutes(inspect_end_dt - inspect_begin_dt)- inspect_free_period) * inspect_minute_price.
Если inspect_price  > 0, то учитываем коэффициенты, как для этапа бронирования.
Записываем времена и стоимость этапа.

###Поездка

На этапе поездки фиксируем trip_begin_dt. При переходе на этап парковки в trip_time_total записываем разницу между текущим временем 
и trip_begin_dt. При возобновлении поездки фиксируем trip_replay_dt. 
При новой парковке добавляем в общее время поезки разницу между текущим временем и trip_replay_dt.
При завершении этапа фиксируем trip_dist и trip_end_dt.
trip_price = minutes(trip_time_total) * trip_minute_price
Если trip_price > 0, то учитываем коэффициенты.

Если пробег trip_dist у car_rent больше порога (trip_base_dist у car_rent_tariff), то
trip_dist_price  = (trip_dist - trip_base_dist) * trip_dist_km_price, иначе trip_dist_price = 0.
Если полученная trip_dist_price  > 0, то учитываем коэффициенты, как для этапа бронирования.
Также увеличиваем mileage_today и mileage_total у car.

###Парковка

Аналогично этапу бронирования рассчитываем стоимость парковки, только учитываем, что этап
может повторяться неоднократно: park_time_total увеличиваем на разницу текущего времени и park_replay_dt (как на этапе поездки).
park_total = minutes(park_time_total) * park_minute_price.
Если park_total > 0, то учитываем коэффициенты.

###Завершение поездки

При нажатии на кнопку "Завершить" записываем время завершения соответствующего этапа, рассчитываем
стоимость данного этапа, записываем. Считаем total_time как разность времени окончания этапа, на котором завершили поездку 
(reserve_end_dt, inspect_end_dt, trip_end_dt или park_end_dt) и reserve_begin_dt.
Далее рассчитываем суммарную стоимость аренды total_price:
total_price = reserve_price + inspect_price + trip_price + park_price
Если total_price больше rent_time_max_price у car_rent_tariff, 
то total_price = rent_time_max_price.

Если пробег за день trip_dist у car_rent больше порога (trip_base_dist у car_rent_tariff), то total_price увеличиваем на trip_dist_price.
Если у автомобиля дополнительная опция, например option_baby_chair_is установлена в true, то
считаем option_baby_chair_price считаем как option_baby_chair_tariff у класса автомобиля (car_class) умножить на total_time:
option_baby_chair_price = option_baby_chair_tariff * total_time
Если option_baby_chair_price больше option_baby_chair_day_max у car_class, то option_baby_chair_price=option_baby_chair_day_max
Добавляем total_price += option_baby_chair_price

Проверяем полученную стоимость со стоимостью из приложения. Если нет соответствия, то выдаем ошибку. 
(Проверка на случай вредительского вмешательства или попытки изменения стоимости аренды.)
Если стоимость совпадает, то status аренды (car_rent) переводим  в режим finished, авто переводим в статус free, 
создаем заявку в очередь на списание денег.