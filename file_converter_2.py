def main():
    
    for i in range(10):
        name = "j309_" + str(i+1)
        convert(name)
    

    
def convert(name):
    import numpy as np


    f = open(name + ".mm", "r")
    w = open("use_" + name + ".dzn", "w")
    w.write("Act = {")

    n_jobs = 20
    nb_modes = 10

    if f.mode == 'r':
        lines = f.readlines()
        l = 0
        for x in lines:
            if(l == 5):
                n_jobs = int(x[33] + x[34])
                nb_modes = ((n_jobs - 2) * 3 + 2)
                succ = np.zeros((n_jobs,3), dtype=int)
                mdur = np.zeros((nb_modes) , dtype=int)
                mrreq = np.zeros((nb_modes,4), dtype=int)

            if(l == 6):
                horizon = int( x[33] + x[34] + x[35])

            if(l == 8):
                renew = int(x[33])

            if(l == 9):
                n_renew = int(x[33])
            
            if(l == 10):
                d_cons = int(x[33])
            
            if (l > 17 and l < 17 + n_jobs):

                # writing Act
                if(x[2].isspace()):
                    w.write(x[3] + ",")
                else:
                    w.write(x[2] + x[3] + ",")
                
                n_suc = int(x[23])
                

                for i in range(n_suc):
                    if(x[34 + i*4].isspace()):
                        succ[l-18][i] = int( x[35 + i*4] )
                    else:
                        succ[l-18][i] = int( x[34 + i*4] + x[35 + i*4] )
                
            
            if( l == 17 + n_jobs):
                if(x[2].isspace()):
                    w.write( x[3] )
                else:
                    w.write( x[2] + x[3] )


                # writing Succ
                w.write("};\n\n succ = [")
                for i in range(n_jobs): 
                    w.write("{")
                    for j in range(3):
                        if succ[i][j] != 0 :
                            if  j !=2 and succ[i][j+1] != 0: 
                                w.write(str(succ[i][j]) + ",")
                            else:
                                w.write(str(succ[i][j]))
                    if i == n_jobs-1:
                        w.write("}")
                    else:
                        w.write("},")

                w.write("];\n\n")


                # writing Mod
                w.write("Mod = {")
                for i in range(nb_modes -1):
                    w.write(str(i+1) + ",")
                w.write(str(nb_modes) + "};\n\n")

                # writing Res and rtype (always the same)
                w.write("Res = {1,2,3,4};\n\nrtype = [1,1,2,2];\n\n")

                #writing mact
                w.write("mact = [1,")
                for i in range(n_jobs-2):
                    w.write(str(i+2) + ",")
                    w.write(str(i+2) + ",")
                    w.write(str(i+2) + ",")
                w.write(str(n_jobs) + "];\n\n")

            
            if (l >= 22 + n_jobs) and (l < (22 + n_jobs + nb_modes)):
                if x[14].isspace():
                    mdur[l - (22 + n_jobs)] = x[15]
                else:
                    mdur[l - (22 + n_jobs)] = x[14] + x[15]
                
                for i in range(4):
                    if x[22 + i*5].isspace():
                        mrreq[ l - (22 + n_jobs) ][i] = x[23 + i*5]
                    else:
                        mrreq[ l - (22 + n_jobs) ][i] = x[22 + i*5] + x[23 + i*5]

            
            if (l == (22 + n_jobs + nb_modes + 3)):
                
                #writing rcap
                w.write("rcap = [")
                for i in range(3):
                    if x[2+ i*5].isspace():   
                        if x[3 + i*5].isspace():
                            w.write(x[4 + i*5] + ",")
                        else:
                            w.write(x[3 + i*5] + x[4 + i*5] + ",")
                    else:
                        w.write(x[2 + i*5] + x[3 + i*5] + x[4 + i*5] + ",")
                
                if x[18].isspace():
                    w.write(x[19] + "];\n\n")
                else:
                    w.write(x[18] + x[19] + "];\n\n")
            



            l = l + 1
    
    #writing mdur
    w.write("mdur = [")
    for i in range(nb_modes-1):
        w.write(str(mdur[i]) + ",")
    
    w.write(str(mdur[nb_modes-1]) + "];\n\n")
    
    #writing mrreq
    w.write("mrreq = [|")
    for col in range(4):    
        for i in range(nb_modes):
            w.write(str(mrreq[i][col]) + ",")
        
        if col != 3:
            w.write("\n|")

    w.write("|];\n\n")
           

if __name__=="__main__":
    main()
