% Search Strategies
ann: arreq_s = int_search([ arreq [n, a] | n in NRes , a in Act], smallest, indomain_min, complete);
ann: mode_s = bool_search(mrun, input_order, indomain_max,  complete);
ann: start_s = int_search( start, smallest, indomain_min,  complete);

ann: arreqThenModeThenStart = seq_search([arreq_s, mode_s, start_s]); % strat 4

% Search
solve :: arreqThenModeThenStart minimize makespan;