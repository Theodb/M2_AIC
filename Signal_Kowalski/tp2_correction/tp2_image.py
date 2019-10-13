# -*- coding: utf-8 -*-
"""
Created on Fri Sep 27 17:46:47 2019

@author: wariche1
"""
from PIL import Image

import matplotlib.pyplot as plt
import matplotlib.image as mpimg
import numpy as np

from scipy import ndimage
from scipy import signal


def rgb2gray(rgb):
    return np.dot(rgb[...,:3], [0.299, 0.587, 0.144])


def show(ref_image, filtered_image1, filtered_image2, filter_name):
   # plot the result
   fig = plt.figure()
   fig.suptitle(("Filter ", filter_name))
   plt.gray()  
   ax1 = fig.add_subplot(121)  
   ax2 = fig.add_subplot(122)
   ax1.imshow(filtered_image1)
   ax2.imshow(filtered_image2)
   plt.show() 

# Open barbara image
img = Image.open("barbara.jpg")
img_png = mpimg.imread("barbara.png")
img_gray = rgb2gray(img_png)

# plot image
fig = plt.figure()
plt.gray()  
plt.imshow(img)
plt.show() 

# apply gradient filter
# filtre passe haut.
# C'est un filtre qui va mettre en valeur les hautes frequences c'est a dire 
# les contour et le bruit.
# Les basse frequence sont ramené vers 0.
# Le filtre gradian ne detecte les contour que dans une direction.
# Ici quand la direction horizontale, on voit que le pied de la table 
# n'est pas detecté.
gradient_filter = np.array([[1,1,1],[0,0,0],[-1,-1,-1]])
gradient_h = signal.convolve2d(img_gray, gradient_filter)  
gradient_filter = np.array([[1,0,-1],[1,0,-1],[1,0,-1]])
gradient_v = signal.convolve2d(img_gray, gradient_filter)
show(img, gradient_h, gradient_v, "gradient")


# apply sobel filter
# Filtre passe haut.
# C'est un filtre qui va mettre en valeur les hautes frequences c'est a dire 
# les contour et le bruit.
# Le filtre sobel est est composé de 2 filtres gradian un pour l'horizontale
# , un pour la verticale. Ceci lui permet de detecter les contours dans les 
# deux direction contrairement a un simple le filtre gradian.
# A noter qu'un filtre sobel selon un axe donné est equivalent 
# a un filtre gradient.
sobel_gradient = ndimage.sobel(img_gray, axis=0)
sobel = ndimage.sobel(img_gray)
show(img, sobel_gradient, sobel, "sobel")


# apply averaging filter
# Filtre passe bas
# Le filtre moyenneur convolue l'image a l'aide d'une simple moyenne
# C'est a dire que les pixel eloigné du centre de la convolution on le meme
# poid que ceux qui en sont plus proche.
# C'est un filtre qui va réduire du bruit mais entrainer beaucoup
# de flou, d'autant plus que la fenetre de convolution est grande.
average_10 = ndimage.median_filter(img, size=10)
average_20 = ndimage.median_filter(img, size=20)
show(img, average_10, average_20, "average")


# apply Gaussian filter
# Filtre passe bas
# Le fitre gaussien convolue l'image a l'aide d'une gaussien.
# C'est a dire que les pixel les plus eloigné du centre de la convolution
# on moins de poid. 
# Ce qui permet par rapport au filtre moyenneur d'avoir moins de flou, tout
# en réduissant le bruit.
# On peut faire varier sigma, si le sigma est tres grand on se rapproche d'un
# filtre moyenneur. Si sima est tres petit il y aura peu d'impact sur l'image. 
gaussian_5 = ndimage.gaussian_filter(img, sigma=5)
gaussian_10 = ndimage.gaussian_filter(img, sigma=10)
show(img, gaussian_5, gaussian_10, "gaussian")


