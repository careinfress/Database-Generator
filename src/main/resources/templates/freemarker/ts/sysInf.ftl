${gen.setType("sysInf")}
package ${entity.packages.sysInf};

import fai.comm.util.*;

/**
 *
 * @author ${developer.author}
 * @date ${date.toString("yyyy-MM-dd HH:mm:ss")}
 */
public interface Sys${entity.name} extends CorpKit {

    int add${entity.name}(int aid, Param info) throws Exception;

    int add${entity.name}(int aid, Param info, Ref<Integer> idRef) throws Exception;

    int set${entity.name}(int aid, int id, ParamUpdater updater) throws Exception;

    Param get${entity.name}(int aid, int id) throws Exception;

    FaiList<Param> get${entity.name}List(int aid, SearchArg searchArg) throws Exception;
}
