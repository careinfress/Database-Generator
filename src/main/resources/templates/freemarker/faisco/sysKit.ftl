${gen.setType("sysKit")}
package ${entity.packages.sysKit};

import fai.app.*;
import fai.cli.*;
import fai.comm.util.*;
import fai.web.App;
import fai.web.Core;
import fai.web.Kit;
import fai.web.WebException;
import fai.web.inf.*;

/**
 *
 * @author ${developer.author}
 * @date ${date.toString("yyyy-MM-dd HH:mm:ss")}
 */
@Kit(Kit.Type.SYS)
public class Sys${entity.name}Impl extends CorpKitImpl implements Sys${entity.name} {

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
    public int update${entity.name}(int id, ParamUpdater updater) throws Exception {
        int rt = Errno.OK;
        if (id <= 0 || updater == null || updater.isEmpty()) {
            rt = Errno.ARGS_ERROR;
            App.logErr(rt, "args err; aid=%d, id=%d", m_aid, id);
            return rt;
        }
        ${entity.name.cli} cli = createCli();
        rt = cli.set${entity.name}(m_aid, id, updater);
        if (rt != Errno.OK) {
            App.logErr(rt, "update${entity.name} error; aid=%d, id=%d", m_aid, id);
            return rt;
        }
        Log.logStd("add${entity.name} success; aid=%d, id=%d", m_aid, id);
        return rt;
    }

    @Override
    public int del${entity.name}(int id) throws Exception {
        int rt = Errno.OK;
        if (id <= 0) {
            rt = Errno.ARGS_ERROR;
            App.logErr(rt, "args err; aid=%d, id=%d", m_aid, id);
            return rt;
        }
        ${entity.name.cli} cli = createCli();
        rt = cli.del${entity.name}(m_aid, id);
        if (rt != Errno.OK) {
            App.logErr(rt, "del${entity.name} error; aid=%d, id=%d", m_aid, id);
            return rt;
        }
        Log.logStd("del${entity.name} success; aid=%d, id=%d", m_aid, id);
        return rt;
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
    public FaiList<Param> get${entity.name}List(SearchArg searchArg) throws Exception {
        int rt = Errno.OK;
        FaiList<Param> list = new FaiList<Param>();

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