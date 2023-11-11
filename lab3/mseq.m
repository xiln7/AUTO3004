function ms = mseq()
	% Define the initial state and feedback polynomial of the m-sequence
	initial_state = [1, 0, 0, 0, 0, 0, 1, 1];
	feedback_polynomial = [0, 0, 0, 1, 1, 1, 0, 1];

	% Length of the m-sequence
	sequence_length = 2^length(initial_state) - 1;

	% Generate the m-sequence
	ms = zeros(1, sequence_length);
	for i = 1:sequence_length
		ms(i) = initial_state(8);
		feedback = mod(sum(feedback_polynomial.*initial_state) , 2);
		initial_state = [feedback, initial_state(1:7)];
	end

	% Normalize the m-sequence
	for i = 1:sequence_length
		if ms(i) == 0
			ms(i) = 1;
		else
			ms(i) = -1;
		end
	end
end