extends Control

var is_visible = true
var balance = 0.0
var direction = 0.0

var balance_speed = 0.10
var balance_speed_max = 3
var balance_speed_min = -3
var balance_endpoint_buffer = 0.1

var recovery_rate = 0.5
var volatility_rate = 0.01
var seconds_count = 0

@onready var balance_grabber: HSlider = $Panel/BalanceGrabber
@onready var rate_timer: Timer = $RateTimer
@onready var balance_panel: Panel = $Panel

func _ready() -> void:
	balance_grabber.value = 0
	direction = [-1.0, 1.0].pick_random()
	balance_speed = direction * balance_speed
	rate_timer.start()

func _process(delta: float) -> void:
	if (GameState.dying or GameState.lose_balance) and is_visible :
		is_visible = false
		balance_panel.visible = false

	if (
		is_visible and
		GameState.start_run and
		not GameState.game_over and
		not GameState.lose_balance and
		not GameState.player_hurt and
		not GameState.dying
		):
		if rate_timer.paused:
			rate_timer.paused = false

		# Figuring out balance_speed
		if Input.is_action_pressed("left"):
			direction = -1.0
			balance_speed += direction * recovery_rate * delta
		elif Input.is_action_pressed("right"):
			direction = 1.0
			balance_speed += direction * recovery_rate * delta

		balance_speed += direction * volatility_rate
		balance_speed = clampf(balance_speed, balance_speed_min, balance_speed_max)

		# Figuring out balance
		balance += balance_speed * delta
		balance = clampf(balance, balance_grabber.min_value - balance_endpoint_buffer, balance_grabber.max_value + balance_endpoint_buffer)

		# Update slider
		balance_grabber.value = balance
		#printt("balance", balance, "balance_speed", balance_speed, "direction", direction)

		if (
			balance <= balance_grabber.min_value - balance_endpoint_buffer or
			balance >= balance_grabber.max_value + balance_endpoint_buffer
		):
			GameState.lose_balance = true

	else:
		if not rate_timer.paused:
			rate_timer.paused = true

func _on_rate_timer_timeout() -> void:
	seconds_count += 0.01
	var rate_increase = exp(seconds_count) * 0.001
	volatility_rate += rate_increase
	#printt("volatility_rate", volatility_rate, "seconds_count", seconds_count, "rate_increase", rate_increase)
