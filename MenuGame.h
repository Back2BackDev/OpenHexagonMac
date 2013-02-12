// Copyright (c) 2013 Vittorio Romeo
// License: Academic Free License ("AFL") v. 3.0
// AFL License page: http://opensource.org/licenses/AFL-3.0

#ifndef MENUGAME_H
#define MENUGAME_H

#include <vector>
#include <SFML/Graphics.hpp>
#include <SFML/System.hpp>
#include <SFML/Window.hpp>
#include <SFML/Audio.hpp>
#include <SSVStart.h>
#include <SSVEntitySystem.h>
#include "Data/LevelData.h"
#include "Data/StyleData.h"
#include "Global/Assets.h"
#include "Global/Config.h"
#include "Utils/Utils.h"

namespace hg
{
	enum StateType { LEVEL_SELECTION, PROFILE_CREATION, PROFILE_SELECTION };

	class HexagonGame;

	class MenuGame
	{
		private:
			ssvs::GameState game;
			ssvs::GameWindow& window;
			sses::Manager manager;
			ssvs::Camera backgroundCamera, menuCamera;
			StateType state;

			float inputDelay{0};
			std::vector<std::string> levelDataIds;
			int currentIndex{0};
			int packIndex{0};

			std::string profileCreationName;
			int profileIndex{0};

			std::vector<float> difficultyMultipliers;
			int difficultyMultIndex{0};

			void update(float mFrameTime);
			void draw();
			void drawLevelSelection();
			void drawProfileCreation();
			void drawProfileSelection();
			void setIndex(int mIndex);
			void positionAndDrawCenteredText(sf::Text& mText, sf::Color mColor, float mElevation, bool mBold);

			LevelData levelData;
			StyleData styleData;
			sf::Text 	title1{"open", getFont("imagine"), 80},
						title2{"hexagon", getFont("imagine"), 160},
						title3{ssvs::Utils::toStr(getVersion()), getFont("imagine"), 25},
						title4{"clone of ""super hexagon"" by terry cavanagh\n              programmed by vittorio romeo\n                         music by bossfight", getFont("imagine"), 15},
						levelTime{"", getFont("imagine"), 50},
						cProfText{"", getFont("imagine"), 25},
						levelName{"", getFont("imagine"), 80},
						levelDesc{"", getFont("imagine"), 35},
						levelAuth{"", getFont("imagine"), 20},
						levelMusc{"", getFont("imagine"), 20};

		public:
			HexagonGame* hgPtr;

			MenuGame(ssvs::GameWindow& mGameWindow);

			void init();
			void drawOnWindow(sf::Drawable&);

			ssvs::GameState& getGame();
	};
}
#endif // MENUGAME_H
