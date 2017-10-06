function [ statesObservations ] = hmmStateObservationCreator( qsr,dist )
%HMMSTATEOBSERVATIONCREATOR Summary of this function goes here
%   Detailed explanation goes here

states = [];
observations = [];
for i = 1 : size(qsr,1)
  
  states = [states qsr{i}(1,2:end) qsr{i}(2,2:end) qsr{i}(3,2:end)];
  observations = [observations dist{i}(1,2:end) dist{i}(2,2:end) dist{i}(3,2:end)];
  
end


statesObservations = [states;observations];
end

