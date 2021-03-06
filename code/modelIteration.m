%------------Initialise model
clear all

%------------- CONFIG ------------------------
M=6400; % no of connections
N=3200; % no of people
k=2*M/N; % avg degree
gamma=10; % N/G
G=N/gamma; % number of opinion
phi=0.458; % transition probability
%------------- ENDCONFIG -----------------------

% opinion array
Individuals=randi(G,N,1);

% connectivity matrix (NxN)
% choose random position and set to 1 representing a connection
% do M times
Connections=zeros(N,N);
for i=1:M
    x=randi(N);
    y=randi(N);
    % fill both entries to represent full connectivity
    Connections(x,y)=1;
    Connections(y,x)=1;
end

% I assign 2 times M entries in the connection matrix
% Except for when the value is in the diagonal, I set it twice to the same
% index, so subtract it
double_connections=(2*M-sum(sum(Connections))-sum(diag(Connections)))/2;
disp("Initialisation complete. " + double_connections + ...
     " double connection(s).")
%------------- CONFIG ---------
no_of_runs=5; % amount of times to run simulation
duration=1000000; % number of iterations
%------------- ENDCONFIG ------

ClusterSizes=zeros(G,no_of_runs);

for j=1:no_of_runs
    %------------- Iteration
    %"Run " + j + " of " + no_of_runs + " runs."
    disp("Run " + j + " of " + no_of_runs + " runs.")
    for i=1:duration
        person=randi(N);
        op=Individuals(person);
        Friends=find(Connections(person,:)==1); % person's friends (indices)
        no_of_friends=size(Friends,2);
        if no_of_friends==0 % Skip if no friends
            continue
        else
            number=rand();
            if number<phi % move edge
                % remove random friend
                goodbye_friend=randi(no_of_friends);
                Connections(person,Friends(goodbye_friend))=0;
                Connections(Friends(goodbye_friend),person)=0;
                % find people with same opinion and set connection
                SameOpinionFriends=find(Individuals==op); % indices of friends
                new_friend_number=randi(size(SameOpinionFriends,2));
                new_friend=SameOpinionFriends(new_friend_number,1);
                Connections(person,new_friend)=1;
                Connections(new_friend,person)=1;
            else % change opinion
                opinion_friend=randi(no_of_friends);
                Individuals(person)=Individuals(Friends(opinion_friend));
            end
        end
    end
    for i=1:G
        ClusterSizes(i,j)=size(find(Individuals==i),1);
    end
end