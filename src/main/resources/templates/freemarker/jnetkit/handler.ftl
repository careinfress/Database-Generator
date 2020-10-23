${gen.setType("svr")}
package ${entity.packages.svr};

import fai.app.*;
import fai.comm.cache.redis.*;
import fai.comm.cache.redis.config.*;
import fai.comm.cache.redis.pool.*;
import fai.comm.jnetkit.server.ServerConfig;
import fai.comm.jnetkit.server.fai.*;
import fai.comm.jnetkit.server.fai.annotation.*;
import fai.comm.util.*;
import java.io.IOException;

/**
 *
 * @author ${developer.author}
 * @date ${date.toString("yyyy-MM-dd HH:mm:ss")}
 */
public class ${entity.name}Handler extends FaiHandler {

    public ${entity.name}Handler(FaiServer server, DaoPool daoPool, RedisCacheManager cache, PosReadWriteLock lock) {
        super(server);
        m_daoPool = daoPool;
        m_lock = lock;
        m_cache = cache;
        m_config = server.getConfig();
        m_svrOption = m_config.getConfigObject(${entity.name.svr}.SvrOption.class);

        m_${entity.name.firstLower}Proc = new ${entity.name}Proc(daoPool, cache, lock);
    }

    @Cmd(${entity.name.def}.Protocol.Cmd.ADD)
    @WrittenCmd
    public int add${entity.name}(final FaiSession session,
                                @ArgAid final int aid,
                                @ArgFlow final int flow,
                                @ArgParam(keyMatch = ${entity.name.def}.Protocol.Key.INFO,
                                            classDef = ${entity.name.def}.Protocol.class,
                                            methodDef = "get${entity.name.def}") final Param param)
    throws IOException {
        return m_${entity.name.firstLower}Proc.add${entity.name}(session, aid, flow, param);
    }


    @Cmd(${entity.name.def}.Protocol.Cmd.SET)
    @WrittenCmd
    public int set${entity.name}(final FaiSession session,
                                @ArgAid int aid,
                                @ArgFlow final int flow,
                                @ArgBodyInteger(value = ${entity.name.def}.Protocol.Key.ID) Integer id,
                                @ArgParamUpdater(keyMatch = ${entity.name.def}.Protocol.Key.UPDATER,
                                                classDef = ${entity.name.def}.Protocol.class,
                                                methodDef =  "get${entity.name.def}") final  ParamUpdater updater)
    throws IOException {
        return m_${entity.name.firstLower}Proc.set${entity.name}(session, aid, flow, id, updater);
    }


    @Cmd(${entity.name.def}.Protocol.Cmd.DEL)
    @WrittenCmd
    public int del${entity.name}(final FaiSession session,
                                @ArgFlow final int flow，
                                @ArgBodyInteger(value = ${entity.name.def}.Protocol.Key.ID) Integer id)
    throws IOException {
        return m_${entity.name.firstLower}Proc.del${entity.name}(session, flow, id, updater);
    }


    @Cmd(${entity.name.def}.Protocol.Cmd.GET)
    public int get${entity.name}(final FaiSession session,
                                @ArgFlow final int flow，
                                @ArgBodyInteger(value = ${entity.name.def}.Protocol.Key.ID) Integer id)
    throws IOException {
        return m_${entity.name.firstLower}Proc.get${entity.name}(session, flow, id);
    }


    @Cmd(${entity.name.def}.Protocol.Cmd.GET_LIST)
    public int get${entity.name}List(final FaiSession session,
                                @ArgFlow final int flow,
                                @ArgSearchArg(${entity.name.def}.Protocol.Key.SEARCH_ARG) SearchArg searchArg)
    throws IOException {
        return m_${entity.name.firstLower}Proc.get${entity.name}List(session, flow, searchArg);
    }


    private DaoPool m_daoPool;
    private ServerConfig m_config;
    private RedisCacheManager m_cache;
    private PosReadWriteLock m_lock;
    private ${entity.name.svr}.SvrOption m_svrOption;
    private ${entity.name}Proc m_${entity.name.firstLower}Proc;

}