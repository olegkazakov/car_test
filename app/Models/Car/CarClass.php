<?php

namespace App\Models\Car;

use Illuminate\Database\Eloquent\Model;

class CarClass extends Model
{
    protected $table = 'car_class';

    /**
     * Get cars with current class.
     */
    /*public function car_class()
    {
        return $this->hasMany('App\Models\Car');
    }*/
}
