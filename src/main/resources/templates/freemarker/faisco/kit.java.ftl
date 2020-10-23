${gen.setType("kit")}
package ${entity.packages.kit};

import fai.app.*;
import fai.cli.*;
import fai.comm.util.*;
import fai.web.*;
import fai.web.inf.*;

/**
 * kit：${entity.comment}
 *
 * @author ${developer.author}
 * @date ${date.toString("yyyy-MM-dd HH:mm:ss")}
 */
@Kit(Kit.Type.CORP)
public class ${entity.name}Impl extends CorpKitImpl implements ${entity.name} {

    @Override
    public int add${entity.name}(Param info) throws Exception {
        return add${entity.name}(info, null);
    }

    @Override
    public int add${entity.name}(Param info, Ref<Integer> idRef) throws Exception {
        int rt = Errno.OK;
        if (info == null || info.isEmpty()) {
            rt = Errno.ARGS_ERROR;
            App.logErr(rt, "add${entity.name} error; info is null");
            return rt;
        }

        ${entity.name.cli} cli = createCli();
        rt = cli.add${entity.name}(m_aid, info, idRef);
        if (rt != Errno.OK) {
            App.logErr(rt, "add${entity.name} error; aid=%d, info=%s", m_aid, info);
            return rt;
        }
        Log.logStd("add${entity.name} success; aid=%d, info=%s", m_aid, info);
        return rt;
    }

    @Override
    public int update${entity.name}(int id, ParamUpdater updater) {
        int rt = Errno.OK;
        if (id <= 0 || updater == null || updater.isEmpty()) {
            rt = Errno.ARGS_ERROR;
            App.logErr(rt, "args err; aid=%d, id=%d", m_aid, id);
            return rt;
        }
        ${entity.name.cli} cli = createCli();
        rt = cli.update${entity.name}(m_aid, id, updater);
        if (rt != Errno.OK) {
            App.logErr(rt, "update${entity.name} error; aid=%d, id=%d", m_aid, id);
            return rt;
        }
        Log.logStd("add${entity.name} success; aid=%d, id=%d", m_aid, id);
        return rt;
    }

    /**
     * 业务处理：删除 <strong>${entity.comment}</strong>
     *
     * @param id   主键ID
     * @param matcher 选择条件封装
     * @return 请求处理结果
     */
    public int del${entity.name}(int id, ParamMatcher matcher) {
    	return del${entity.name}(0, id, matcher);
    }

    @Override
    public Param get${entity.name}(int id) throws Exception {
        int rt = Errno.OK;
        Param info = new Param();
        if (id <= 0) {
            return info;
        }

        ${entity.name.cli} cli = createCli();
        rt = cli.get${entity.name}(m_aid, id, info);
        if (rt != Errno.OK && rt != Errno.NOT_FOUND) {
            throw new WebException(rt, "get${entity.name} error");
        }
        return info;
    }

    @Override
    public FaiList<Param> get${entity.name}List(SearchArg searchArg) {
        int rt = Errno.OK;
        FaiList<Param> list = new FaiList<Param>();
        if (searchArg == null) {
            rt = Errno.ARGS_ERROR;
            throw new WebException(rt, "searchArg error");
        }
        if (searchArg.matcher == null) {
            searchArg.matcher = new ParamMatcher();
        }

        // 只允许查自己的
        SearchArg searchArgTmp = new SearchArg();
        searchArgTmp.matcher = new ParamMatcher(${entity.name.def}.Info.AID, ParamMatcher.EQ, m_aid);
        searchArg.matcher.and(searchArgTmp.matcher);

        ${entity.name.cli} cli = createCli();
        rt = cli.get${entity.name}List(m_aid, searchArg, list);
        if (rt != Errno.OK && rt != Errno.NOT_FOUND) {
            throw new WebException(rt, "get${entity.name}List error");
        }
        return list;
    }

    private ${entity.name.cli} createCli() throws Exception {
        ${entity.name.cli} cli = new ${entity.name.cli}(Core.getFlow());
        if (!cli.init()) {
            throw new WebException("${entity.name.cli} init error");
        }
        return cli;
    }


}