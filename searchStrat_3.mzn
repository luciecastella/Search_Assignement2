% Search Strategies
ann:mode_s= bool_search(mrun,  input_order , indomain_max ,  complete);
ann:start_s= int_search( start ,  smallest ,  indomain_min ,  complete);
ann:adur_s= int_search(adur ,  smallest ,  indomain_min ,  complete);
ann:arreq_s= int_search([ arreq [k, i ] | k in NRes , i in Act] , smallest, indomain_min, complete) ;

% 
ann:  modeThenStart =seq_search([ mode_s, start_s]); % strat 1
ann:  arreqThenMode =seq_search([  arreq_s, mode_s]); % strat 2
ann:  arreqThenStart =seq_search([  arreq_s, start_s]); % strat 3
ann:  arreqThenModeThenStart =seq_search([  arreq_s, mode_s, start_s]); % strat 4
ann:  durThenStart =seq_search([  adur_s, mode_s]); % strat 5
ann:  durThenModeThenStart =seq_search([  adur_s, mode_s, start_s]); % strat 6

% Search
solve :: arreqThenStart minimize makespan;