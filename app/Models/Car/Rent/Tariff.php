<?php

namespace App\Models\Car\Rent;

use Illuminate\Database\Eloquent\Model;

class Tariff extends Model
{
    protected $table = 'car_rent_tariff';

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
            'title', 'description', 'reserve_free_period', 'reserve_minute_price', 'reserve_free_time_start',
            'reserve_free_time_end', 'inspect_free_period', 'inspect_minute_price', 'trip_minute_price',
            'trip_base_dist', 'trip_dist_km_price', 'rent_time_max_price', 'park_minute_price', 'park_free_time_start',
            'park_free_time_end', 'car_class_koef_is', 'user_privilege_koef_is', 'user_group_koef_is'
    ];
}
