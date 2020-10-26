${gen.setType("cli")}
package ${entity.packages.cli};

import fai.app.*;
import fai.comm.cli.*;
import fai.comm.util.*;

/**
 *
 * @author ${developer.author}
 * @date ${date.toString("yyyy-MM-dd HH:mm:ss")}
 */
public class ${entity.name.cli} extends TsClient {
    private static ParamDef PARAM_DEF = ${entity.name.def}.Protocol.getParamDef(${entity.name.def}.Protocol.Def.${entity.name.def.underscoreUpper});

    public ${entity.name.cli}(int flow) {
        super(flow, "${entity.name.cli}");
    }
    
    public boolean init() {
        return init("${entity.name.cli}", true);
    }

    public int add${entity.name}(int aid, Param info, Ref<Integer> idRef) {
        m_rt = Errno.ERROR;
        
        // 数据校验
        if (info == null || info.isEmpty()) {
            m_rt = Errno.ARGS_ERROR;
            Log.logErr(m_rt, "args error");
            return m_rt;
        }
        
        // send数据对象
        FaiBuffer sendBody = new FaiBuffer(true);
        info.toBuffer(sendBody, ${entity.name.def}.Protocol.Key.INFO, PARAM_DEF);

        // 发包给svr
        m_rt = super.baseAddFun(${entity.name.def}.Protocol.Cmd.ADD, sendBody, aid, TsViewerDef.Protocol.Key.ID, idRef);

        return m_rt;
    }

    // 修改
    public int set${entity.name}(int aid, int id, ParamUpdater updater) {
        m_rt = Errno.ERROR;

        // 数据校验
        if (aid < 1 || id < 1 || updater == null || updater.isEmpty()) {
            m_rt = Errno.ARGS_ERROR;
            Log.logErr(m_rt, "args error;aid=%s, id=%s;", m_aid, id);
            return m_rt;
        }

        // send数据对象
        FaiBuffer sendBody = new FaiBuffer(true);
        updater.toBuffer(sendBody, ${entity.name.def}.Protocol.Key.UPDATER, PARAM_DEF);
        sendBody.putInt(${entity.name.def}.Protocol.Key.ID, id);

        // 发包给svr
        m_rt = super.baseSetFun(${entity.name.def}.Protocol.Cmd.SET, sendBody, aid);

        return m_rt;
    }

    // 获取信息
    public int get${entity.name}(int aid, int id, Param info) {
        m_rt = Errno.ERROR;

        // 数据校验
        if (aid < 1 || id < 1) {
            m_rt = Errno.ARGS_ERROR;
            Log.logErr(m_rt, "args error");
            return m_rt;
        }

        Ref<FaiBuffer> recvBodyRef = new Ref<FaiBuffer>();

        // send数据对象
        FaiBuffer sendBody = new FaiBuffer(true);
        sendBody.putInt(${entity.name.def}.Protocol.Key.ID, id);

        // 发包给svr
        m_rt = super.baseGetFun(${entity.name.def}.Protocol.Cmd.GET, sendBody, aid, recvBodyRef);
        if (m_rt != Errno.OK) {
            return m_rt;
        }

        // 把回包对象解析到info
        Ref<Param> infoRef = new Ref<Param>(info);
        int infoKey = ${entity.name.def}.Protocol.Key.INFO;
        m_rt = super.unpackInfo(recvBodyRef.value, PARAM_DEF, infoKey, infoRef);

        return m_rt;
    }

    public int get${entity.name}List(int aid, SearchArg searchArg, FaiList<Param> infoList) {
        return get${entity.name}List(aid, searchArg, infoList, "");
    }
    
    // 获取列表
    public int get${entity.name}List(int aid, SearchArg searchArg, FaiList<Param> infoList, String fieldStr) {
        m_rt = Errno.ERROR;
    
        // send数据对象
        FaiBuffer sendBody = new FaiBuffer(true);
        searchArg.toBuffer(sendBody, ${entity.name.def}.Protocol.Key.SEARCH_ARG);
        sendBody.putString(${entity.name.def}.Protocol.Key.FIELD, fieldStr);
    
        Ref<FaiBuffer> recvBodyRef = new Ref<FaiBuffer>();

        // 发包给svr
        m_rt = super.baseGetFun(${entity.name.def}.Protocol.Cmd.GET_LIST, sendBody, aid, recvBodyRef);
        if (m_rt != Errno.OK) {
            return m_rt;
        }

        // 把回包对象解析到list
        Ref<FaiList<Param>> infoListRef = new Ref<FaiList<Param>>(infoList);
        int infoKey = ${entity.name.def}.Protocol.Key.INFO_LIST;
        int totalKey = ${entity.name.def}.Protocol.Key.TOTAL_SIZE;
        m_rt = super.unpackList(recvBodyRef.value, searchArg, PARAM_DEF, infoKey, totalKey, infoListRef);

        return m_rt;
    }
}
