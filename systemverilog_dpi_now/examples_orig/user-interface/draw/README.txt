
Build DRAW Library

  1. Use the EGGX080 installed here, or get EGGX from Internet. (See google EGGX)
     Latest on Feb 22, 2005 - EGGX080.

       http://phe.phyas.aichi-edu.ac.jp/~cyamauch/eggx_procall/EGGX080.tar.gz

	 Unpack the download.

	   tar xvfz EGGX080.tar.gz


  2. Compile EGGX. 

       cd EGGX080
	   make
	   cd ..


  3. Compile draw library, and simple example.

       make


  4. Test. Run the simple example.

       setenv DISPLAY XXXXXX
       ./mandel

