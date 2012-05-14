using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Audio;
using Microsoft.Xna.Framework.Content;
using Microsoft.Xna.Framework.GamerServices;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;
using Microsoft.Xna.Framework.Media;

namespace ZombieEscape
{
    /// <summary>
    /// This is the main type for your game
    /// </summary>
    public class ZombieEscapeGame : Microsoft.Xna.Framework.Game
    {
        GraphicsDeviceManager graphics;
        ScreenManager screenManager;


        static readonly string[] preloadAssets =
        {
            "gradient",
        };

        public ZombieEscapeGame()
        {
            Content.RootDirectory = "Content";

            graphics = new GraphicsDeviceManager(this);
            //GraphicsAdapter.UseReferenceDevice = true;
            graphics.PreferredBackBufferWidth = 1280;
            graphics.PreferredBackBufferHeight = 720;
            
            // Create the screen manager component.
            screenManager = new ScreenManager(this);

            Components.Add(screenManager);
            Components.Add(new GamerServicesComponent(this));

            // Activate the first screens.
            screenManager.AddScreen(new BackgroundScreen(), null);
            screenManager.AddScreen(new MainMenuScreen(), null);
        }

        protected override void LoadContent()
        {
            foreach (string asset in preloadAssets)
            {
                Content.Load<object>(asset);
            }
        }


        protected override void Draw(GameTime gameTime)
        {
            graphics.GraphicsDevice.Clear(Color.Black);

            // The real drawing happens inside the screen manager component.
            base.Draw(gameTime);
        }
    }

    static class Program
    {
        static void Main()
        {
            using (ZombieEscapeGame game = new ZombieEscapeGame())
            {
                game.Run();
            }
        }
    }
}
