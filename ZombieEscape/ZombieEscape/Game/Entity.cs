using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.Xna.Framework;

namespace ZombieEscape
{
    abstract public class Entity
    {
        public Vector3 Location { get; set; }

        public float Rotation { get; set; }

        protected Entity() { }



    }
}
