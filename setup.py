##################################################
##          Universidad Sergio Arboleda         ##
##  Escuela de Ciencias exactas e Ingeniería    ##
##  Ingeniería de Sistemas y Telecomunicaciones ##
##                                              ##
## Algoritmo de orbitas optimizado              ##
## en Cython.                                   ##
##                                              ##
## Autores:                                     ##
##    -Juan Pablo Blanco                        ##
##    juan.blanco01@correo.usa.edu.co           ##
##                                              ##
## Fecha: 14/05/21                              ##
##################################################

#from distutils.core import setup, Extension
#from Cython.Build import cythonize

#exts = (cythonize("Cy_simulator.pyx"))

#setup(ext_modules=exts)
from distutils.core import setup
from Cython.Build import cythonize
from Cython.Distutils import build_ext
from distutils.extension import Extension
import numpy


#exts = (cythonize('Cy_functionE.pyx'))
ext_modules=[ Extension("Cy_simulator",
              ["Cy_simulator.pyx"],
              libraries=["m"],
              extra_compile_args=["-O3", "-ffast-math", "-march=native"])]

setup(name = 'Cy_simulator', cmdclass={"build_ext": build_ext},
	ext_modules=ext_modules, 
      include_dirs=[numpy.get_include()])


