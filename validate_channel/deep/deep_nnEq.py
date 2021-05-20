# Make and train a Deep NN Eq in Python

import scipy.io as spio
import numpy as np
import math

import keras
from keras.models import Sequential
from keras.layers import Dense, Dropout
from keras.optimizers import SGD
from keras.losses import MeanSquaredError

num_classes = 2
batch_size = 128
epochs = 5000


# Load the data
mat = spio.loadmat('deepSNR30.mat', squeeze_me=True)
x_train = mat['x_train']
x_valid = mat['x_valid']
x_test = mat['x_test']
y_train = mat['y_train']
y_valid = mat['y_valid']
y_test = mat['y_test']


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


# Formatting
fmtLen = int(math.ceil(math.log(max(batch_size, y_valid.shape[0]),10)))

# Define the network
model = Sequential()
model.add(Dense(50, activation='tanh', input_dim=18))
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
