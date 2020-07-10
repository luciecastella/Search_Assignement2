% Search Strategies
ann: arreq_s = int_search([arreq [n, a] | n in NRes, a in Act], smallest, indomain_min, complete);
ann: mode_s = bool_search(mrun, input_order, indomain_max, complete);

ann: arreqThenMode = seq_search([arreq_s, mode_s]); % strat 2

% Search
solve :: arreqThenMode minimize makespan;