HParse grammar wordnet
HDMan -m -w wlist -n models0 -l dlog dict lexicon
HCopy -T 1 -C ParamConfig-FBANK -S param.list
HCompV -C TrainConfig-FBANK -f 0.01 -m -S train.scp -M hmm0 proto-8s-32f
HCompV -C TrainConfig-FBANK -f 0.01 -m -S train.scp -M hmm0 proto-3s-32f
HERest -C TrainConfig-FBANK -I train.mlf -t 250.0 150.0 1000.0 -S train.scp -H hmm0/hmmdefs -M hmm1 models0
HERest -C TrainConfig-FBANK -I train.mlf -t 250.0 150.0 1000.0 -S train.scp -H hmm1/hmmdefs -M hmm2 models0
HERest -C TrainConfig-FBANK -I train.mlf -t 250.0 150.0 1000.0 -S train.scp -H hmm2/hmmdefs -M hmm3 models0
HERest -C TrainConfig-FBANK -I train.mlf -t 250.0 150.0 1000.0 -S train.scp -H hmm3/hmmdefs -M hmm4 models0
HERest -C TrainConfig-FBANK -I train.mlf -t 250.0 150.0 1000.0 -S train.scp -H hmm4/hmmdefs -M hmm5 models0
HERest -C TrainConfig-FBANK -I train.mlf -t 250.0 150.0 1000.0 -S train.scp -H hmm5/hmmdefs -M hmm6 models0
HVite -H hmm6/hmmdefs -S test.scp -i recout.mlf -w wordnet -p -70.0 -s 0 dict models0
HResults -e ??? SENT-START -e ??? SENT-END -t -I testref.mlf models0 recout.mlf
