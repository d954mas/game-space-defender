local COMMANDS = {}

COMMANDS.PlayerAppearedCommand = require "world.game.command.player_appeared_command"
COMMANDS.EnemiesSpawnCommand = require "world.game.command.enemies_spawn_command"
COMMANDS.GameWinCommand = require "world.game.command.game_win_command"
COMMANDS.GameLoseCommand = require "world.game.command.game_lose_command"

return COMMANDS