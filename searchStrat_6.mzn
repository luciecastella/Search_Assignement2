% Search Strategies
ann: adur_s = int_search(adur, smallest, indomain_min, complete);
ann: mode_s = bool_search(mrun, input_order, indomain_max, complete);
ann: start_s = int_search(start, smallest, indomain_min, complete);

ann: durThenModeThenStart = seq_search([adur_s, mode_s, start_s]); % strat 6

% Search
solve :: durThenModeThenStart minimize makespan;