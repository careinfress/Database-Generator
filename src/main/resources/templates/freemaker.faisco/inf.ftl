package fai.web.inf;

import fai.comm.util.*;

public interface ${className} extends CorpKit{

    int add${methodName}(Param info) throws Exception;

    int add${methodName}(Param info, Ref<Integer> idRef) throws Exception;

    int set${methodName}(int id, ParamUpdater updater) throws Exception;

    Param get${methodName}(int id) throws Exception;

    FaiList<Param> get${methodName}List(SearchArg searchArg) throws Exception;
}
