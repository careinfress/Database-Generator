${gen.setType("inf")}
package ${entity.packages.inf};

import fai.comm.util.*;

/**
 *
 * @author ${developer.author}
 * @date ${date.toString("yyyy-MM-dd HH:mm:ss")}
 */
public interface ${entity.name.inf} extends CorpKit {

    int add${entity.name}(Param info) throws Exception;

    int add${entity.name}(Param info, Ref<Integer> idRef) throws Exception;

    int set${entity.name}(int id, ParamUpdater updater) throws Exception;

    Param get${entity.name}(int id) throws Exception;

    FaiList<Param> get${entity.name}List(SearchArg searchArg) throws Exception;
}
