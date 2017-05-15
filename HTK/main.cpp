#include <iostream>
#include <string>
#include <dirent.h>
#include <sys/stat.h>
#include <errno.h>
#include <iostream>
#include <fstream>
#include <locale>
#include <stdio.h>

using namespace std;

string cisla[] = {"NULA", "JEDNA", "DVA", "TRI", "CTYRI", "PET", "SEST", "SEDM", "OSM", "DEVET"};

bool has_suffix(const std::string &str, const std::string &suffix)
{
    return str.size() >= suffix.size() &&
    str.compare(str.size() - suffix.size(), suffix.size(), suffix) == 0;
}

bool isDir(string dir)
{
    struct stat fileInfo;
    stat(dir.c_str(), &fileInfo);
    if (S_ISDIR(fileInfo.st_mode)) {
        return true;
    } else {
        return false;
    }
}

void listFiles(string baseDir, string fileExtension, string mainDir, bool recursive)
{
    DIR *dp;
    ofstream myfile;
    std::locale loc;
    struct dirent *dirp;
    if ((dp = opendir(baseDir.c_str())) == NULL) {
        cout << "[ERROR: " << errno << " ] Couldn't open " << baseDir << "." << endl;
        return;
    } else {
        while ((dirp = readdir(dp)) != NULL) {
            if (dirp->d_name[0] != '.') {
                if (isDir(baseDir + dirp->d_name) == true && recursive == true) {
                    listFiles(baseDir + dirp->d_name + "/", fileExtension, mainDir, true);
                } else {
                    if(has_suffix(dirp->d_name, fileExtension)){
                        string file_name = dirp->d_name;
                        file_name = file_name.substr(0, file_name.size()-4);
                        
                        //Nazev slova
                        myfile.open(baseDir + "/" + file_name + ".txt");
                        myfile << cisla[file_name[1] - '0'] << "\n";
                        myfile.close();
                        
                        //Obsah nahravky
                        myfile.open(baseDir + "/" + file_name + ".lab");
                        myfile << "sil\n";
                        for(auto elem : cisla[file_name[1] - '0']) {
                            myfile << std::tolower(elem,loc);
                        }
                        myfile << "\nsil\n";
                        myfile.close();
                        
                        //Trenovaci data
                        if(file_name[file_name.size()-1] != '4') {
                            //Trenovaci nahravky
                            myfile.open(mainDir + "train.list", std::ios_base::app);
                            myfile << baseDir + "/" + dirp->d_name + "\n";
                            myfile.close();
                            
                            //Trenovaci nahravky a jejich obsah
                            if (!std::ifstream(mainDir + "source.mlf"))
                            {
                                myfile.open(mainDir + "source.mlf");
                                myfile << "#!MLF!#\n";
                                myfile.close();
                            }
                            myfile.open(mainDir + "source.mlf", std::ios_base::app);
                            myfile << "\"" + baseDir + file_name + ".lab\"\n";
                            myfile << "sil\n";
                            for(auto elem : cisla[file_name[1] - '0']) {
                                myfile << std::tolower(elem,loc);
                            }
                            myfile << "\nsil\n.\n";
                            myfile.close();
                            
                            //Zparametrizovane trenovaci nahravky
                            myfile.open(mainDir + "train.scp", std::ios_base::app);
                            myfile << baseDir + file_name + ".fbank\n";
                            myfile.close();
                        } else {
                            //Zparametrizovane testovaci nahravky
                            myfile.open(mainDir + "test.scp", std::ios_base::app);
                            myfile << baseDir + file_name + ".fbank\n";
                            myfile.close();
                            
                            //Melo byt rozpoznano
                            if (!std::ifstream(mainDir + "testref.mlf"))
                            {
                                myfile.open(mainDir + "testref.mlf");
                                myfile << "#!MLF!#\n";
                                myfile.close();
                            }
                            myfile.open(mainDir + "testref.mlf", std::ios_base::app);
                            myfile << "\"" + baseDir + file_name + ".lab\"\n";
                            myfile << cisla[file_name[1] - '0'] + "\n.\n";
                            myfile.close();
                        }
                        
                        //Parametrizace souboru
                        myfile.open(mainDir + "param.list", std::ios_base::app);
                        myfile << baseDir + "/" + dirp->d_name + " " + baseDir + file_name + ".fbank\n";
                        myfile.close();
                        
                        //Trenovaci nahravky a jejich obsah
                        if (!std::ifstream(mainDir + "train.mlf"))
                        {
                            myfile.open(mainDir + "train.mlf");
                            myfile << "#!MLF!#\n";
                            myfile.close();
                        }
                        myfile.open(mainDir + "train.mlf", std::ios_base::app);
                        myfile << "\"" + baseDir + file_name + ".lab\"\n";
                        myfile << "sil\n";
                        for(auto elem : cisla[file_name[1] - '0']) {
                            myfile << std::tolower(elem,loc);
                        }
                        myfile << "\nsil\n.\n";
                        myfile.close();
                    }
                }
            }
        }
        closedir(dp);
    }
}

int main(int argc, char *argv[])
{
    if(argc < 2 || argc > 4){
        cout << "Wrong number of arguments." << endl << "Need folder path, file extension and main directory" << endl;
        cout << argc << endl;
        return -1;
    }
    std::string record_path = argv[1];
    std::string file_extension = argv[2];
    std::string main_dir = argv[3];
    remove((main_dir + "train.list").c_str());
    remove((main_dir + "source.mlf").c_str());
    remove((main_dir + "param.list").c_str());
    remove((main_dir + "train.scp").c_str());
    remove((main_dir + "train.mlf").c_str());
    remove((main_dir + "test.scp").c_str());
    remove((main_dir + "testref.mlf").c_str());
    listFiles(record_path, file_extension, main_dir, true);
    
    return 0;
}
