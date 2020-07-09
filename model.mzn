include "globals.mzn";

set of int: Act; % Activities
set of int: Mod; % Modes
array[Mod] of Act: mact; % Corresponding  activity of a mode
array[Act] of set of Mod: mode = [{m | m in Mod where mact[m] = a} | a in Act]; % Modes  for  each  activity
array[Act] of set of Act: succ; % Successors

set of int: Res; % Resources
array[Res] of int: rtype ; % Resource type  (1:  renewable;  2: non−renewable)
set of int: RRes = {r|r in Res where rtype [r] = 1}; % Renewable resources
set of int: NRes = {r|r in Res where rtype [r] = 2}; % Non-renewable resources

array[Mod] of int: mdur; % Duration  of modes
array[Res, Mod] of int: mrreq ; % Resource requirements of modes
array[Res] of int: rcap; % Resource  capacity
array[Mod] of var bool: mrun; % Whether a mode is executed or not


int: MAX = sum(a in Act)( max([ mdur[m] | m in mode[a] ]) ); % Initial upper bound

array[Act] of var 0..MAX: start; % Start time activities
array[Act] of var int: adur = [let {var {mdur [m]|m in mode [i]} : x} in x | i in Act]; % Duration of activities
array[Res, Act] of var int: arreq = array2d(Res, Act, [let {var {mrreq [r,m] | m in mode [a]}: x} in x | r in Res, a in Act]); % Resource requirements of activities
var 0..MAX: makespan; % Objective variable

% Activities and mode constraints
constraint  forall(a in Act)
  ( adur[a] = sum(m in mode[a]) (mdur[m] * mrun[m]) );
  
constraint  forall(a in Act, r in Res)
  ( arreq [r, a] = sum(m in mode[a]) (mrreq[r,m] * mrun[m]) );
  
constraint  forall(a in Act)
  ( sum(m in mode[a]) (mrun[m]) = 1 );
  
% Precedence constraints  
constraint  forall(a in Act, s in succ[a]) 
  ( start [a] + adur [a] <= start[s] );

% Renewable resource constraints
constraint  forall(r in RRes) 
  ( cumulative(start, adur, [arreq[r,a] | a in Act], rcap[r]) );

% Non-renewable resource constraints
constraint  forall(r in NRes) 
  ( sum(a in Act) (arreq [r, a]) <= rcap[r] );

% Pairwise non-overlapping constraints
predicate post_noc_disj(int: i, int:  j) = (start [i] + adur [i] <= start[j] \/ start [j] + adur [j] <= start [i]);

predicate post_noc_mode(int: i, int: j) =
  forall(mi in mode[i], mj in mode [ j ] where  exists (k in RRes)(mrreq [k,mi] + mrreq [k,mj] > rcap [k]) )
    ( (mrun[mi] /\ mrun [ mj ] ) -> (start[i] + mdur[mi]<= start [j] \/ start [j] + mdur[mj] <= start [i]) );
    
predicate post_noc_rres(int: i, int: j) =
  forall(k in RRes) 
    ( (arreq [k, i] + arreq [k, j] > rcap [k]) -> (start [i] + adur [i] <= start [j] \/ start[j] + adur [j] <= start[i]) );

% Objective constraints
constraint makespan = max(i in Act where succ [i] = {})(start [i] + adur [i]);

constraint forall(i in Act where succ [i]={})
  (start [i] + adur [i] <= makespan);





