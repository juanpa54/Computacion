
#cython: language_level=3
cimport cython
import numpy as np
cimport numpy as np



cdef extern from "math.h":
    double sqrt(double x) nogil
    double atan2(double x, double y) nogil
    double cos(double x) nogil
    double sin(double x) nogil


@cython.cdivision(True)
@cython.boundscheck(False) 
@cython.wraparound(False)



cdef class Body(object):
    """Subclass of Turtle representing a gravitationally-acting body.

    Extra attributes:
    mass : mass in kg
    vx, vy: x, y velocities in m/s
    px, py: x, y positions in m
    """

    cdef public double vx, vy, px, py, mass
    cdef public str name

    def __init__(self):
        # Alguna posición
        self.name = 'Body'
        self.mass = 0.0
        self.vx = 0.0
        self.vy = 0.0
        self.px = 0.0
        self.py = 0.0
    
#@cython.boundscheck(False)  # Deactivate bounds checking
#@cython.wraparound(False)   # Deactivate negative indexing.
    @cython.cdivision(True)  

    cdef tuple attraction(Body self, Body other):
        """(Body): (fx, fy)

        Returns the force exerted upon this body by the other body.
        """
        # Report an error if the other object is the same as this one.

        # Compute the distance of the other body.
        cdef double sx = self.px
        cdef double sy = self.py
        cdef double ox = other.px
        cdef double oy = other.py
        cdef double dx = (ox-sx)
        cdef double dy = (oy-sy)
        cdef double d = sqrt(dx**2 + dy**2)

        # Report an error if the distance is zero; otherwise we'll
        # get a ZeroDivisionError exception further down.

        # Compute the force of attraction
        cdef double f = 6.67428e-11 * self.mass * other.mass / (d**2)

        # Compute the direction of the force.
        cdef double theta = atan2(dy, dx)
        cdef double fx = cos(theta) * f
        cdef double fy = sin(theta) * f
        return fx, fy

"""def update_info(step, bodies):
    #Displays information about the status of the simulation.
    print('Step #{}'.format(step))
    for body in bodies:
        s = '{:<8}  Pos.={:>6.2f} {:>6.2f} Vel.={:>10.3f} {:>10.3f}'.format(
            body.name, body.px/AU, body.py/AU, body.vx, body.vy)
        print(s)
    print()
"""

@cython.cdivision(True)
#@cython.boundscheck(False) # turn off bounds-checking for entire function
#@cython.wraparound(False)  # turn off negative index wrapping for entire function

#def loop(np.ndarray[np.float_t, ndim=1] bodies):
def loop(list bodies):
    """([Body])

    Never returns; loops through the simulation, updating the
    positions of all the provided bodies.
    """
    cdef double timestep = 24*3600  # One day
    cdef size_t n = len(bodies)
    
    
    #cdef np.ndarray[ndim=1, dtype=np.float64_t] body
    #cdef np.ndarray[ndim=1, dtype=np.float64_t] other
    """
    for body in bodies:
        body.penup()
        body.hideturtle()
    """
    cdef int step = 1
    """ 365 days in order to complete earth's cycle"""
    
    cdef double total_fx 
    cdef double total_fy 
    cdef double fx, fy
    
    cdef dict force
    cdef Body body, other
    cdef double mass, vx, vy
    #cdef double fx, fy
    
    while (step<=365 * 1000):
        #update_info(step, bodies)
        step += 1
        force = {}
        #for body in range(n):
        for body in bodies:
            # Add up all of the forces exerted on 'body'.
            total_fx = 0.0
            total_fy = 0.0
           
            for other in bodies:
            #for other in range (n):
                # Don't calculate the body's attraction to itself
                if body is other:
                    continue
                fx, fy = body.attraction(other)
                total_fx += fx
                total_fy += fy

            # Record the total force exerted.
            force[body] = (total_fx, total_fy)
            
	    
        # Update velocities based upon on the force.
           
        for body in bodies:
            fx, fy = force[body]
            body.vx += fx / body.mass * timestep
            body.vy += fy / body.mass * timestep

            # Update positions
            body.px += body.vx * timestep
            body.py += body.vy * timestep
            #body.goto(body.px*SCALE, body.py*SCALE)
            #body.dot(3)
