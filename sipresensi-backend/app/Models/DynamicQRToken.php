<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class DynamicQRToken extends Model
{
    use HasFactory;

    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'dynamic_qr_tokens';

    /**
     * Indicates if the model should be timestamped.
     *
     * @var bool
     */
    public $timestamps = false;

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'token',
        'created_at',
        'expires_at',
        'used',
        'used_by',
        'used_at',
    ];

    /**
     * The attributes that should be cast to native types.
     *
     * @var array
     */
    protected $casts = [
        'created_at' => 'datetime',
        'expires_at' => 'datetime',
        'used_at' => 'datetime',
        'used' => 'boolean',
    ];

    /**
     * Scope a query to only include active tokens.
     *
     * @param  \Illuminate\Database\Eloquent\Builder  $query
     * @return \Illuminate\Database\Eloquent\Builder
     */
    public function scopeActive($query)
    {
        return $query->where('used', false)
                     ->where('expires_at', '>', now());
    }

    /**
     * Scope a query to only include expired tokens.
     *
     * @param  \Illuminate\Database\Eloquent\Builder  $query
     * @return \Illuminate\Database\Eloquent\Builder
     */
    public function scopeExpired($query)
    {
        return $query->where('expires_at', '<=', now());
    }

    /**
     * Check if the token is still valid
     *
     * @return bool
     */
    public function isValid()
    {
        return !$this->used && $this->expires_at > now();
    }

    /**
     * Mark the token as used
     *
     * @param  int  $userId
     * @return bool
     */
    public function markAsUsed($userId = null)
    {
        $this->used = true;
        $this->used_by = $userId;
        $this->used_at = now();
        return $this->save();
    }

    /**
     * Generate a new dynamic QR token
     *
     * @return self
     */
    public static function generateNewToken()
    {
        $token = new self();
        $token->token = bin2hex(random_bytes(16));
        $token->created_at = now();
        $token->expires_at = now()->addSeconds(10); // Token kadaluarsa dalam 10 detik
        $token->used = false;
        $token->save();

        return $token;
    }
}