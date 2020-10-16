package fai.web.inf;

import fai.comm.util.*;

public interface Sys${className} extends CorpKit{

    int add${methodName}(int aid, Param info) throws Exception;

    int add${methodName}(int aid, Param info, Ref<Integer> idRef) throws Exception;

    int set${methodName}(int aid, int id, ParamUpdater updater) throws Exception;

    Param get${methodName}(int aid, int id) throws Exception;

    FaiList<Param> get${methodName}List(int aid, SearchArg searchArg) throws Exception;
}
