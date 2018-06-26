<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Car extends Model
{
    protected $table = 'car';

    /**
     * Get car class.
     */
    public function car_class()
    {
        return $this->belongsTo('App\Models\Car\CarClass');
    }
}
