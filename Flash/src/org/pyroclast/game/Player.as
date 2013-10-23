package org.pyroclast.game
{
	import org.flixel.FlxEmitter;
	import org.flixel.FlxObject;
	import org.flixel.FlxParticle;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSave;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import org.flixel.system.FlxDebugger;
	
	import org.pyroclast.system.*;
	/**
	 * ...
	 * @author Matthew Everett
	 */
	public class Player extends FlxSprite
	{
		
		var playState:PlayState;
		
		public var doubleJumpBoots:Boolean;
		public var gunLevel:int; //0 = no gun, levels from there
		public var groundPoundItem:Boolean;
		
		public var hasDoubleJumped:Boolean;
		public var jumpImpulse:Number;
		var jumpTimer:Number;
		public var maxJumpTimer:Number;
		
		//Particle effects on death
		public var deathParticleEmitter:FlxEmitter;
		public var deathParticleSprite:FlxParticle;
		
		//How long to let the player's death effects go before respawning
		public var deathResetTimer:Number;
		public var deathResetTimerMax:Number;
		
		//Where the player returns after death
		public var saveRoomIndex:int;
		public var saveRoomPosition:FlxPoint;
		
		//Health
		public var currentHealth:int;
		public var maxHealth:int;
		
		//Timer for invincibility after being hit
		public var invincibleTimer:Number;
		public var invincibleTimerMax:Number;
		
		public function Player(state:PlayState, x:Number, y:Number)
		{
			super(x, y);
			playState = state;
			facing = RIGHT;
		}
		
		public function init():void
		{
			this.loadGraphic(Resources.playerSpritesheet, true, true, 16, 32);
			addAnimation("stand", new Array(0,0), 5, true);
			addAnimation("jump", new Array(6,6), 5, true);
			addAnimation("run", new Array(1, 2, 3, 4), 10, true);
			
			deathParticleEmitter = new FlxEmitter(x, y, 100);
			deathParticleEmitter.at(this);
			deathParticleEmitter.setXSpeed(200, -200);
			deathParticleEmitter.setYSpeed( -150, 0);
			deathParticleEmitter.bounce = .8;
			deathParticleEmitter.gravity = 40;
			deathParticleEmitter.particleDrag = new FlxPoint(20, 0);
			deathParticleEmitter.setRotation(0, 0);
			playState.deathParticleGroup.add(deathParticleEmitter);
			
			
			for (var i:int = 0; i < 100; i++)
			{
				deathParticleSprite = new FlxParticle();
				deathParticleSprite.makeGraphic(2, 2, 0xff0022ff);
				deathParticleSprite.visible = false;
				deathParticleEmitter.add(deathParticleSprite);
			}
			
			height = 25;
			offset.y = 7;
			width = 12;
			offset.x = 2;
			
			maxVelocity.x = 100;
			maxVelocity.y = 300;
			acceleration.y = 500;
			drag.x = maxVelocity.x * 8;
			
			jumpTimer = 0;
			maxJumpTimer = 15;
			jumpImpulse = -170;
			
			doubleJumpBoots = false;
			hasDoubleJumped = false;
			
			deathResetTimerMax = 3;
			deathResetTimer = -1;
			
			FlxG.watch(maxVelocity, "y", "yMaxVelocity");
			FlxG.watch(acceleration, "y", "gravity");
			FlxG.watch(this, "jumpImpulse");
			FlxG.watch(this, "maxJumpTimer");
			FlxG.watch(velocity, "y", "yVel");
			FlxG.watch(this, "deathResetTimer");
		}
		
		public override function update():void
		{
			super.update();
			
			//If player is doing his death animation, just update that
			if (deathResetTimer >= 0)
			{
				deathResetTimer -= FlxG.elapsed;
				if (deathResetTimer <= 0)
				{
					deathParticleEmitter.kill();
					deathParticleEmitter.revive();
					playState.OnPlayerDeath();
				}
				return;
			}
			
			acceleration.x = 0;
			if(FlxG.keys.LEFT)
				acceleration.x = -maxVelocity.x*4;
			if(FlxG.keys.RIGHT)
				acceleration.x = maxVelocity.x * 4;
				
			//Jumping
			
			if (jumpTimer > 0)
				jumpTimer--;
				
			if (isTouching(FlxObject.FLOOR))
			{
				hasDoubleJumped = false;
			}
			
			if (!FlxG.keys.SPACE)
				jumpTimer = 0;
			
			if (FlxG.keys.SPACE && jumpTimer > 0)
			{
				velocity.y = jumpImpulse;
			}
			
			if (FlxG.keys.justPressed("SPACE") && (isTouching(FlxObject.FLOOR)))
			{
				jumpTimer = maxJumpTimer;
				velocity.y = jumpImpulse;
			}
			else if (FlxG.keys.justPressed("SPACE") && !isTouching(FlxObject.FLOOR)
						&& doubleJumpBoots && !hasDoubleJumped)
			{
				hasDoubleJumped = true;
				jumpTimer = maxJumpTimer;
				velocity.y = jumpImpulse;
			}
			
			if (FlxG.keys.K)
			{
				die();
			}
			
			if (FlxG.keys.justPressed("Z"))
			{
				shootBullet();
			}
			
				
			updateSprite();
				
			checkForExits();
		}
		
		public function shootBullet():void
		{
			var bullet:FlxSprite = new FlxSprite(x, y);
			bullet.loadGraphic(Resources.bulletSprite);
			if (facing == LEFT)
			{
				bullet.velocity.x = -200;
			}
			else
			{
				bullet.velocity.x = 200;
			}
			playState.bulletsGroup.add(bullet);
			playState.actorArray.push(bullet);
		}
		
		public function updateSprite():void
		{
			if (velocity.x == 0)
				play("stand");
			if (velocity.x < 0)
			{
				facing = LEFT;
				play("run");
			}
			if (velocity.x > 0)
			{
				facing = RIGHT;
				play("run");
			}
			if (!isTouching(FlxObject.FLOOR))
			{
				play("jump");
			}
		}
		
		public function checkForExits():void
		{
			if (x < 0 - 10)
				playState.ChangeRoom("left");
			else if (x > 310)
				playState.ChangeRoom("right");
			else if (y < 0 - 25)
				playState.ChangeRoom("up");
			else if (y > 240)
				playState.ChangeRoom("down");
		}
		
		public function die():void
		{
			deathResetTimer = deathResetTimerMax;
			visible = false;
			deathParticleEmitter.at(this);
			deathParticleEmitter.start();
		}
		
	}

}