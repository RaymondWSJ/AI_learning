function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

%part 1
%create y_matric
y_matric = zeros(m,num_labels);
for c=1:m
y_matric(c,y(c)) = 1;
end

%add x0 into X
X_1 = [ones(m,1),X];
%hidden layer 2 equal X*Theta1
%A2 = X * Theta1';
Z2 = X_1 * Theta1';
A2 = 1.0 ./ (1.0 + exp(-(X_1 * Theta1')));
%add a20 into A2;
A2_1 = [ones(size(X, 1),1),A2];
%output layer  equal A2*Theta2
%A3 = A2 * Theta2';
Z3 = A2_1 * Theta2';
A3 = 1.0 ./ (1.0 + exp(-(A2_1 * Theta2')));

J= 1/m * sum(sum ( - y_matric .* log(A3) -( 1 - y_matric) .* log(1 - A3))) + lambda / (2 * m) * (sum(sum(Theta1(:,2:size(Theta1,2)).^2)) + sum(sum(Theta2(:,2:size(Theta2,2)).^2))) ;

%part 2
%use A3 - y can easily get delta3 which is the last delta
delta3 = A3 - y_matric;
%before calculte the 
%delta2 = delta3 * Theta2_1 .* sigmoidGradient(A2);
Theta2_1 = Theta2(:,2:size(Theta2,2));
delta2 = delta3 * Theta2_1 .* sigmoidGradient(Z2);
%delta2 = delta3 * Theta2_1 .* A2 .* (1 - A2);

D2 = delta3' * A2_1;

D1 = delta2' * X_1;

%best regularization so far
Theta2_grad = 1/m * (D2 + lambda *([zeros(size(Theta2,1),1),Theta2(:,2:size(Theta2,2))]));

Theta1_grad = 1/m * (D1 + lambda *([zeros(size(Theta1,1),1),Theta1(:,2:size(Theta1,2))]));

% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
