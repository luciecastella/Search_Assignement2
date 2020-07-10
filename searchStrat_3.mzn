% Search Strategies
ann: arreq_s = int_search([arreq [k, i] | k in NRes , i in Act], smallest, indomain_min, complete) ;
ann: start_s = int_search(start, smallest, indomain_min, complete);

ann: arreqThenStart = seq_search([arreq_s, start_s]); % strat 3

% Search
solve :: arreqThenStart minimize makespan;