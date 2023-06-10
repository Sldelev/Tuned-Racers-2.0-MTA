local playerEconomics = {
	-- Начальные деньги
	start_money = 5000,

	-- Дуэли
	duel_bet_min = 5,
	duel_bet_max = 500,

	-- Количество денег за 100000 очков дрифта
	drift_money = 100,
	-- Количество опыта за 100000 очков дрифта
	drift_xp = 25,

	-- Процент от цены авто при продаже
	vehicle_sell_min_mileage_factor = 0.9,
	vehicle_sell_max_mileage = 500,

	race_prizes = {
		{ xp = 6, money = 50 },
		{ xp = 6, money = 45 },
		{ xp = 6, money = 40 },
		{ xp = 6, money = 35 },
		{ xp = 6, money = 30 },
		{ xp = 6, money = 25 },
	},

	tofu_prize = 50,
	tofu_xp = 25,
	tofu_perfect_mul = 0.7,
}

function getEconomicsProperty(name)
	if not name then
		return
	end
	return playerEconomics[name]
end
