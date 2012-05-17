using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.Xna.Framework;

namespace ZombieEscape
{
    public class LevelSection
    {
        public bool EastWall { get; set; }
        public bool WestWall { get; set; }
        public bool NorthWall { get; set; }
        public bool SouthWall { get; set; }

        public Vector2 Location { get; set; }

        public LevelSection(bool eastWall, bool westWall, bool northWall, bool southWall, Vector2 location)
        {
            this.EastWall = eastWall;
            this.WestWall = westWall;
            this.NorthWall = northWall;
            this.SouthWall = southWall;

            this.Location = location;
        }
    }
}
