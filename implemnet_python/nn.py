import pandas as pd
import numpy
import torch
import torch.nn as nn
df_data = pd.read_csv("../validate_channel/data.csv", header=None)
df_target  = pd.read_csv("../validate_channel/target.csv", header=None)

data = df_data.to_numpy()
data_t = torch.from_numpy(data)
target = df_target.to_numpy()
target_t = torch.from_numpy(target)

in_layer = 58
hidden_layer = 70
out_layer = 2

model = nn.Sequential(
        nn.Linear(in_layer,hidden_layer),
        nn.ReLU(),
        nn.Linear(hidden_layer,out_layer),
        )

loss_fn = nn.MSELoss(reduction='sum')

learn_rate = 1e-4

for t in range(500):
    # Forward pass: compute predicted y by passing x to the model. Module objects
    # override the __call__ operator so you can call them like functions. When
    # doing so you pass a Tensor of input data to the Module and it produces
    # a Tensor of output data.
    y_pred = model(data_t)

    # Compute and print loss. We pass Tensors containing the predicted and true
    # values of y, and the loss function returns a Tensor containing the
    # loss.
    loss = loss_fn(y_pred, target_t)
    if t % 100 == 99:
        print(t, loss.item())

    # Zero the gradients before running the backward pass.
    model.zero_grad()

    # Backward pass: compute gradient of the loss with respect to all the learnable
    # parameters of the model. Internally, the parameters of each Module are stored
    # in Tensors with requires_grad=True, so this call will compute gradients for
    # all learnable parameters in the model.
    loss.backward()

    # Update the weights using gradient descent. Each parameter is a Tensor, so
    # we can access its gradients like we did before.
    with torch.no_grad():
        for param in model.parameters():
            param -= learning_rate * param.grad
