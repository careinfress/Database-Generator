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

    public ${entity.name}Handler(FaiServer server) {
        super(server);
        m_config = server.getConfig();
        if (m_config == null) {
            Log.logErr("config null err");
            return;
        }
        // svr 块配置信息
        m_svrOption = m_config.getConfigObject(${entity.name.svr}.SvrOption.class);
        if (svrOption == null) {
            Log.logErr("svrOption null err");
            return;
        }
        // 获取锁信息
        PosReadWriteLock lock = new PosReadWriteLock(svrOption.getLockLength());
        // 获取分布式缓存配置
        ServerConfig.RedisOption cacheOption = config.getRedis();
        if (cacheOption == null) {
            Log.logErr("redis config file not exists");
            return;
        }
        Param cacheInfo = cacheOption.getRedisOption();
        RedisClientConfig redisConfig = new RedisClientConfig(cacheInfo);
        JedisPool jedisPool = JedisPoolFactory.createJedisPool(redisConfig);
        RedisCacheManager cache = new RedisCacheManager(jedisPool, redisConfig.getExpire(), redisConfig.getExpireRandom());
        // 获取db信息
        ServerConfig.DaoOption daoOption = m_config.getDaopool();
        Param daoInfo = daoOption.getDaoPoolOption();
        if (daoInfo == null || daoInfo.isEmpty()) {
            Log.logErr("get daoInfo err");
            return;
        }
        DaoPool daoPool = new DaoPool(m_config.getName(), daoInfo);
        // Proc
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
        return m_${entity.name.firstLower}Proc.del${entity.name}(session, flow, id);
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


    private ServerConfig m_config;
    private ${entity.name}Proc m_${entity.name.firstLower}Proc;

}