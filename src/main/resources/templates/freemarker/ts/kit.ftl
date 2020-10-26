${gen.setType("kit")}
package ${entity.packages.kit};

import fai.app.*;
import fai.cli.*;
import fai.comm.util.*;
import fai.web.*;
import fai.web.inf.*;

@Kit(Kit.Type.CORP)
public class ${entity.name.kit} extends CorpKitImpl implements ${entity.name} {

    public int add${entity.name}(Param info) throws Exception {
        return add${entity.name}(info, null);
    }

    public int add${entity.name}(Param info, Ref<Integer> idRef) throws Exception{
        int rt = Errno.OK;

        if (info == null || info.isEmpty()) {
            rt = Errno.ARGS_ERROR;
            App.logErr(rt, "add${entity.name} info is null err");
            return rt;
        }

        // 创建cli
        ${entity.name.cli} cli = createCli();

        rt = cli.add${entity.name}(m_aid, info, idRef);
            if (rt != Errno.OK) {
            App.logErr(rt, "add${entity.name}  error;aid=%s, info=%s;", m_aid, info);
            return rt;
        }

        Log.logStd("add${entity.name} success;aid=%s, info=%s, c", m_aid, info);
        return rt;
    }

    public int set${entity.name}(int id, ParamUpdater updater) throws Exception {
        int rt = Errno.OK;
        if (id < 1 || updater == null || updater.isEmpty()) {
            rt = Errno.ARGS_ERROR;
            App.logErr(rt, "args err;aid=%s, id=%s;", m_aid, id);
            return rt;
        }

        // 创建cli
        ${entity.name.cli} cli = createCli();

        rt = cli.set${entity.name}(m_aid, id, updater);
        if (rt != Errno.OK) {
            App.logErr(rt, "set${entity.name} error;aid=%s, id=%s;", m_aid, id);
            return rt;
        }

        Log.logStd("set${entity.name} success;aid=%s, id=%s;", m_aid, id);
        return rt;
    }

    public Param get${entity.name}(int id) throws Exception {
        int rt = Errno.OK;
        Param info = new Param();
        if (id < 1) {
            return info;
        }

        // 创建cli
        ${entity.name.cli} cli = createCli();

        rt = cli.get${entity.name}(m_aid, id, info);
        if (rt != Errno.OK) {
            throw new WebException(rt, "get${entity.name} error");
        }

        // 如果不存在的时候
        if (info == null || info.isEmpty()) {
            return new Param();
        }

        return info;
    }

    public FaiList<Param> get${entity.name}List(SearchArg searchArg) throws Exception {
        int rt = Errno.OK;
        FaiList<Param> infoList = new FaiList<Param>();

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

        // 创建cli
        ${entity.name.cli} cli = createCli();

        rt = cli.get${entity.name}List(m_aid, searchArg, infoList);
        if (rt != Errno.OK && rt != Errno.NOT_FOUND) {
            throw new WebException(rt, "search error");
        }

        return infoList;

    }

    private ${entity.name.cli} createCli() throws Exception {
        ${entity.name.cli} cli = new ${entity.name.cli}(Core.getFlow());
        if (!cli.init()) {
            throw new WebException("${entity.name.cli} init error");
        }
        return cli;
    }
}
