#if defined _kart_included
    #endinput
#endif
#define _kart_included

#include <kart_const>

/**
 * Called after creating the car entity
 *
 * @param iPlayer           - Client index
 * @param iCarEnt           - Car entity index
 * @noreturn
 */
forward kart_on_car_create(iPlayer, iCarEnt);

/**
 * Called before changing the game state
 *
 * @param gameState         - Game state
 * @noreturn
 */
forward kart_on_game_state_set(GameState:gameState);

/**
 * Called before changing the player's game state
 *
 * @param iPlayer           - Client index
 * @param playerGameState   - Player's game state
 * @noreturn
 */
forward kart_on_player_game_state_set(iPlayer, PlayerGameState:playerGameState);

/**
 * Called after passing a race lap
 *
 * @param iPlayer           - Client index
 * @param iCurrLap          - Current lap
 * @param bIsFinished       - True if the player finished
 * @noreturn
 */
forward kart_on_player_lap_pass(iPlayer, iCurrLap, bool:bIsFinished);

/**
 * Get a car character (model)
 *
 * @param iCarEnt           - Car entity index
 * @return                  - Car character
 */
native kart_car_get_char(iCarEnt);

/**
 * Get the player's car entity index
 *
 * @param iPlayer           - Client index
 * @return                  - Car entity index
 */
native kart_car_get_entity(iPlayer);

/**
 * Set a car character (model)
 *
 * @param iCarEnt           - Car entity index
 * @param iChar             - Car character
 * @noreturn
 */
native kart_car_set_char(iCarEnt, iChar);

/**
 * Get the game state
 *
 * @return                  - Game state
 */
native GameState:kart_game_state_get();

/**
 * Get the player's game state
 *
 * @param iPlayer           - Client index
 * @return                  - Player's game state
 */
native PlayerGameState:kart_player_game_state_get(iPlayer);
