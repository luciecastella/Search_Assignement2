include "globals.mzn";

set of int: Act; % Activities
set of int: Mod; % Modes
array[Act] of set of Mod: mode = [{m | m in Mod where mact[m] = i} | i in Act]; % Modes  for  each  activity
array[Mod] of Act: mact; % Corresponding  activity of a mode
array[Act] of set of Act: succ; % Successors

set of int: Res; % Resources
array[Res] of int: rtype ; % Resource type  (1:  renewable;  2: non−renewable)
set of int: RRes = {k|k in Res where rtype [k] = 1}; % Renewable resources
set of int: NRes = {k|k in Res where rtype [k] = 2}; % Non-renewable resources

array[Mod] of int: mdur; % Duration  of modes
array[Res,Mod] of int: mrreq ; % Resource requirements  of modes
array[Res] of int: rcap; % Resource  capacity


% Variables
array[Mod] of var bool: mrun;

int: UB = sum(i in Act)(max([mdur[m] | m in mode[i]]));

array[Act] of var 0..UB: start;
array[Act] of var int: adur = [let{var{mdur [m]|m in mode [i]}:x} in x|i in Act];
array[Res,Act] of var int: arreq =array2d(Res,Act,[let{var{mrreq [k,m]|m in mode [i]}:x} in x|k in Res, i in Act]) ;
var 0..UB: makespan;

% Activities and mode constraints
constraint  forall(i in Act)
  (adur [ i ] = sum(m in mode [ i ] ) (mdur [m]*mrun [m] ) ) ;
  
constraint  forall(i in Act,k in Res)
  (arreq [k, i ] = sum(m in mode[ i ]) (mrreq [k,m]*mrun[m] ) ) ;
  
constraint  forall(i in Act)
  (sum(m in mode [ i ] ) (mrun [m] ) = 1) ;
  
% Precedence constraints  
constraint  forall(i in Act,  j in succ [ i ]) 
  (start [ i ] + adur [ i ]<= start[j ]) ;

% Renewable resource constraints
constraint  forall(k in RRes) 
  (cumulative(start, adur, [arreq[k,i] | i in Act], rcap[k]));

% Non-renewable resource constraints
constraint  forall(k in NRes) 
  (sum(i in Act)(arreq [k, i ]) <= rcap[k]);

% Pairwise non-overlapping constraints
predicate post_noc_disj(int: i, int:  j ) = (start [i] + adur [i] <= start[j] \/ start [j] + adur [j] <= start [i]);

predicate post_noc_mode(int: i, int: j) =
  forall(mi in mode[i], mj in mode [ j ] where  exists (k in RRes)(mrreq [k,mi] + mrreq [k,mj] > rcap [k]) )
    ( (mrun[mi] /\ mrun [ mj ] ) -> (start[i] + mdur[mi]<= start [j] \/ start [j] + mdur[mj]<= start [i]) );
    
predicate post_noc_rres(int:i,int:j) =
  forall(k in RRes) 
    ( (arreq [ k , i ] +arreq [k, j ]>rcap [k]) -> ( start [i] + adur [i]<= start [j] \/ start[j]+adur [j]<=start[i]) );

% Objective constraints
constraint makespan = max(i in Act where succ [i] = {})(start [i] + adur [i]);

constraint forall(i in Act where succ [i]={})(start [i] + adur [i] <= makespan);





