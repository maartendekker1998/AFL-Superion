#include <iostream>
#include <cstring>
#include <fstream>
#include "antlr4-runtime.h"
#include "XMLLexer.h"
#include "XMLParser.h"
#include "XMLParserBaseVisitor.h"
#include "XMLParserSecondVisitor.h"
#include <dirent.h>

using namespace antlr4;
using namespace std;

#define MAXSAMPLES 10000
#define MAXTEXT 200
string ret[MAXSAMPLES];

bool is_gramattically_valid(const char* target, size_t len){

	string targetString;

	targetString=string(target,len);
	ANTLRInputStream input(targetString);
	XMLLexer lexer(&input);
	CommonTokenStream tokens(&lexer);
	XMLParser parser(&tokens);

	tree::ParseTree* tree = parser.document();

	if(parser.getNumberOfSyntaxErrors()>0){
		std::cerr<<"NumberOfSyntaxErrors:"<<parser.getNumberOfSyntaxErrors()<<endl;
		return false;
	}else{
		return true;
	}
}

extern "C" int parse(const char* target,size_t len,const char* second,size_t lenS) {
	vector<misc::Interval> intervals;
	vector<string> texts;
	int num_of_samples=0;
	//parse the target
	string targetString;
	try{
		targetString=string(target,len);
		ANTLRInputStream input(targetString);
		//ANTLRInputStream input(target);
		XMLLexer lexer(&input);
		CommonTokenStream tokens(&lexer);
		XMLParser parser(&tokens);
		TokenStreamRewriter rewriter(&tokens);
		tree::ParseTree* tree = parser.document();
		cout<<targetString<<endl;
		if(parser.getNumberOfSyntaxErrors()>0){
			std::cerr<<"NumberOfSyntaxErrors:"<<parser.getNumberOfSyntaxErrors()<<endl;
			return 0;
		}else{
 
			XMLParserBaseVisitor *visitor=new XMLParserBaseVisitor();
			visitor->visit(tree);

			int interval_size = visitor->intervals.size();
            cout << interval_size <<endl;

			for(int i=0;i<interval_size;i++){
				if(find(intervals.begin(),intervals.end(),visitor->intervals[i])!=intervals.end()){
				}else if(visitor->intervals[i].a<=visitor->intervals[i].b){
					intervals.push_back(visitor->intervals[i]);
				}
			}
			int texts_size = visitor->texts.size();
            cout << texts_size << endl;
			for(int i=0;i<texts_size;i++){
				if(find(texts.begin(),texts.end(),visitor->texts[i])!=texts.end()){
				}else if(visitor->texts[i].length()>MAXTEXT){
				}else{
					texts.push_back(visitor->texts[i]);
        			}
			}
            		delete visitor;


			//parse sencond
            //cout << "111second" <<endl;
			string secondString;
			try{
				secondString=string(second,lenS);
				ANTLRInputStream inputS(secondString);
				XMLLexer lexerS(&inputS);
				CommonTokenStream tokensS(&lexerS);
				XMLParser parserS(&tokensS);
				tree::ParseTree* treeS = parserS.document();
                //cout << "second" <<endl;

				if(parserS.getNumberOfSyntaxErrors()>0){
		 			std::cerr<<"second NumberOfSyntaxErrors S:"<<parserS.getNumberOfSyntaxErrors()<<endl;
				}else{
					XMLParserSecondVisitor *visitorS=new XMLParserSecondVisitor();
					visitorS->visit(treeS);
					texts_size = visitorS->texts.size();
					for(int i=0;i<texts_size;i++){
						if(find(texts.begin(),texts.end(),visitorS->texts[i])!=texts.end()){
                        			}else if(visitorS->texts[i].length()>MAXTEXT){
						}else{
							texts.push_back(visitorS->texts[i]);
						}
					}
          			delete visitorS;
				}

				interval_size = intervals.size();
				texts_size = texts.size();
                //cout << interval_size << endl;
                //cout << texts_size << endl;

				for(int i=0;i<interval_size;i++){
					for(int j=0;j<texts_size;j++){
						rewriter.replace(intervals[i].a,intervals[i].b,texts[j]);
                        //cout << 1111 <<endl;
						ret[num_of_samples++]=rewriter.getText();
						if(num_of_samples>MAXSAMPLES){
							break;
						}
					}
					if(num_of_samples>MAXSAMPLES){
						break;
					}
				}
			}catch(range_error e){
				std::cerr<<"range_error"<<second<<endl;
			}
		}
	}catch(range_error e){
		//std::cerr<<"range_error:"<<target<<endl;
	}

	return num_of_samples;
}

extern "C" void fuzz(int index, char** result, size_t* retlen){
  *retlen=ret[index].length();
  *result=strdup(ret[index].c_str());
}

int main(){
	/*
		This function takes one input, parsers it into ASTs and provides all mutations the fuzz()
		function is capable of. For each result the parsing is attempted again to check the 
		validity in adherance to the grammar used.
	*/

    ifstream ifs("/home/maarten/afl_input/test.xml");
    string target( (std::istreambuf_iterator<char>(ifs) ),
                       (std::istreambuf_iterator<char>()));
    ifstream ifs1("/home/maarten/afl_input/test2.xml");
    string second( (std::istreambuf_iterator<char>(ifs1) ),
                       (std::istreambuf_iterator<char>()));

  	int len = target.length();
  	int lenS= second.length();

  	int num_of_samples=parse(target.c_str(),len,second.c_str(),lenS);

	if(is_gramattically_valid(target.c_str(),len)){
		cout<<"VALID ENTRY"<<endl;
    	cout <<target << endl;
		cout<<endl;
	}

	int j = 0;


  	for(int i=0;i<num_of_samples;i++){

     	char* retbuf=nullptr;
     	size_t retlen=0;
     	fuzz(i,&retbuf,&retlen);

		// if(i==20){break;}

		if(is_gramattically_valid(retbuf, retlen)){
			cout<<"VALID ENTRY"<<endl;
			cout<<retlen<<retbuf<<endl;
			cout<<endl;
			j++;
		}else{
			cout<<"NON VALID ENTRY"<<endl;
		}
		// cout<<endl;
  	}

	cout<<j<<endl;

  	cout<<num_of_samples<<endl;
}