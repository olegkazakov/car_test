<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Car;
use App\Models\Car\Rent\Tariff as RentTariff;
use App\Models\User;

// @formatter:off
/**
 * Получение тарифа для указанного пользователя и автомобиля
 * @api {get} /api/car/get-tariff/user_id/car_id
 * @apiName GetTariff
 * @apiGroup Car
 * @apiParam {user-id} user-id Идентификатор пользователя.
 * @apiParam {car-id} car-id Id автомобиля.
 *
 * @apiExample Пример использования:
 *
 * >curl -X GET http://car_test.local/api/car/get-tariff/1/1 \
 * -H "Accept: application/json" \
 * -H "Content-Type: application/json"
 *
 */
// @formatter:on
class CarController extends Controller
{
    /**
     * Method returns tariff for current user and car.
     *
     * @param $user_id
     * @param $car_id
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function getTariff($user_id, $car_id)
    {
        if (!isset($user_id) || !isset($car_id) || !is_numeric($user_id) || !is_numeric($car_id)) {
            return response()->json(['error' => 'Bad request'], 400);
        }

        /** @var User $user */
        $user = User::with('group')->find($user_id);
        if (!isset($user)) {
            return response()->json(['error' => 'User not found'], 404);
        }

        /** @var Car $car */
        $car = Car::with('car_class')->find($car_id);
        if (!isset($car)) {
            return response()->json(['error' => 'Car not found'], 404);
        }

        $tariff = RentTariff::all()->where('car_class_id', $car->car_class_id)->first();

        if ($tariff->user_privilege_koef_is) {
            $tariff['user_privilege_koef'] = $user->privilege_koef;
        }

        if ($tariff->user_group_koef_is) {
            $tariff['user_group_koef'] = $user->group->group_koef;
        }

        if ($tariff->car_class_koef_is) {
            $tariff['car_class_koef'] = $car->car_class->class_koef;
        }

        if ($car->option_baby_chair_is) {
            $tariff['option_baby_chair_tariff'] = $car->car_class->option_baby_chair_tariff;
            $tariff['option_baby_chair_max'] = $car->car_class->option_baby_chair_day_max;
        }

        return response()->json(['$tariff' => $tariff], 200, [], JSON_UNESCAPED_UNICODE);
    }
}
