<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;
use App\Models\DynamicQRToken;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\DynamicQRToken>
 */
class DynamicQRTokenFactory extends Factory
{
    /**
     * The name of the factory's corresponding model.
     *
     * @var string
     */
    protected $model = DynamicQRToken::class;

    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        $createdAt = $this->faker->dateTimeBetween('-1 hour', 'now');
        $expiresAt = (clone $createdAt)->modify('+10 seconds');

        return [
            'token' => bin2hex(random_bytes(16)),
            'created_at' => $createdAt,
            'expires_at' => $expiresAt,
            'used' => false,
            'used_by' => null,
            'used_at' => null,
        ];
    }

    /**
     * Indicate that the token has been used.
     *
     * @return \Illuminate\Database\Eloquent\Factories\Factory
     */
    public function used()
    {
        return $this->state(function (array $attributes) {
            return [
                'used' => true,
                'used_by' => $this->faker->numberBetween(1, 100),
                'used_at' => $this->faker->dateTimeBetween($attributes['created_at'], 'now'),
            ];
        });
    }

    /**
     * Indicate that the token has expired.
     *
     * @return \Illuminate\Database\Eloquent\Factories\Factory
     */
    public function expired()
    {
        return $this->state(function (array $attributes) {
            $expiredAt = (clone $attributes['created_at'])->modify('-1 minute');
            return [
                'expires_at' => $expiredAt,
            ];
        });
    }
}