# -*- coding: utf-8 -*-
"""LMLP_NN.ipynb

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/18UalnXsAwbU2R009pg7Hk4qQd_EWRXzV
"""

from __future__ import print_function

import os
import argparse
import scipy.io as spio
import numpy as np
import math

import keras
from keras.models import Sequential
from keras.layers import Dense, Dropout
from keras.optimizers import SGD
from keras.losses import MeanSquaredError

num_classes = 2
batch_size = 1000
epochs = 5000 


# Load the data
mat = spio.loadmat('tensorflow_comm.mat', squeeze_me=True)
x_train = mat['x_train']
x_valid = mat['x_valid']
x_test = mat['x_test']
y_train = mat['y_train']
y_valid = mat['y_valid']
y_test = mat['y_test']

print(x_train.shape, 'x train shape')
print(y_train.shape, 'y train shape')
print(x_valid.shape, 'x valid shape')
print(y_valid.shape, 'y valid shape')
print(x_test.shape, 'x test shape')
print(y_test.shape, 'y test shape')

# Convert the data to floats between 0 and 1.
x_train = x_train.astype('float32')
x_valid = x_valid.astype('float32')
x_test = x_test.astype('float32')
x_train /= 255
x_valid /= 255
x_test /= 255
print(x_train.shape, 'train samples')
print(x_valid.shape, 'valid samples')
print(x_test.shape, 'test samples')
print(y_train.shape, 'train labels')
print(y_valid.shape, 'valid labels')
print(y_test.shape, 'test labels')
print('Label Examples:\n', y_train[0:9]);

# convert class vectors to binary class matrices
#y_train = keras.utils.to_categorical(y_train, num_classes)
#y_valid = keras.utils.to_categorical(y_valid, num_classes)
#y_test = keras.utils.to_categorical(y_test, num_classes)

# Formatting
fmtLen = int(math.ceil(math.log(max(batch_size, y_valid.shape[0]),10)))

# Define the network
model = Sequential()
model.add(Dense(50, activation='tanh', input_shape=(x_train.shape[1],)))
model.add(Dense(50, activation='tanh'))
model.add(Dense(num_classes, activation='tanh'))

model.summary()

model.compile(loss=keras.metrics.mean_squared_error,
              optimizer=SGD(),
              metrics=[keras.metrics.RootMeanSquaredError(name='rmse')])

history = model.fit(x_train, y_train,
                    batch_size=batch_size,
                    epochs=epochs,
                    verbose=1,
                    validation_data=(x_valid, y_valid))

score = model.evaluate(x_train, y_train, verbose=1)
print('Final Training MSE:', score[0])
print('Final Training RMSE:', score[1])

score = model.evaluate(x_valid, y_valid, verbose=1)
print('Final Validation MSE:', score[0])
print('Final Validation RMSE:', score[1])

score = model.evaluate(x_test, y_test, verbose=1)
print('Test MSE:', score[0])
print('Test RMSE:', score[1])

predictions = model.predict(x_test)
weight = model.get_weights()
#np.savetxt('weight.csv' , weight , fmt='%s', delimiter=',')
print(predictions.shape)
print(predictions[0:9])
print(y_test[0:9])
model.save("deep_model.h5")
