% Search Strategies
ann: adur_s = int_search(adur, smallest, indomain_min, complete);
ann: mode_s = bool_search(mrun, input_order, indomain_max, complete);

ann: durThenStart = seq_search([adur_s, mode_s]); % strat 5

% Search
solve :: durThenStart minimize makespan;