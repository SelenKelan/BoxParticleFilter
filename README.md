# BoxParticleFilter

Matlab code for the Box Particle filtering project. Implementation of Interval class and simulation applications.
Control method adapted for gaussian noise on sensors Based on proportional derivative controller based on the robot vision of self.
Obstacle avoidance implemented by vector field generated from the map of the playground.

## Using it

Matlab standard code, based on rev 2016a

### Installing

Remember to add the whole project to your Matlab folder path.
If necessary, add the whole project to your Matlab startup folder (usually documents/MATLAB)

### Running the show

To run the code, simply run Main.m
When a window appear, calculations have ended. Push any key to launch the representation.

### Visual representation

Three robots appear in the visual representation :
* the black one is the order
* the red one is the self perceived by the robot
* the blue one is the 'real', as where it should be.

Boxes seen underneath are the sum of boxes in which the presence probability is over 80%
When red, they collide with a wall.

## Change the simulation

If you want to change the duration of the simulation, change tn in environement.m :
As an example, for tn=1, the code will run 64 steps.

```
% path
tn=4;
ts = 0.05;
th = 0:ts:tn*pi;
```

If you want to change the playground (add walls, pillars, obstacles), change the envimat in environement.m:
All 2 are places where the robot can go, 1 are where he can't.

```
envimat=2*ones(sqrt(NP),sqrt(NP));
envimat(:,1:4)=1;
envimat(1:4,:)=1;
envimat(:,end-3:end)=1;
envimat(end-3:end,:)=1;
```



## Built Based on :

* [IAMOOC](http://iamooc.ensta-bretagne.fr/) - For the Interval analysis theory basis.

## Authors

* **Evandro Bernardes** - *Initial work* - [evbernardes](https://github.com/evbernardes)
* **Raphaël Abellan--Romita** - *robot control* - [SelenKelan](https://github.com/SelenKelan)

## Acknowledgments

* Hat tip to anyone who's code was used
* Thanks for the UPC-IRI for the internship during which this code was created
* And also to Joaquim Blesa for the help and all the good ideas
