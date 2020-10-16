package fai.svr.${className}Svr;

import fai.app.*;
import fai.comm.cache.redis.*;
import fai.comm.cache.redis.config.*;
import fai.comm.cache.redis.pool.*;
import fai.comm.jnetkit.server.ServerConfig;
import fai.comm.jnetkit.server.fai.*;
import fai.comm.jnetkit.server.fai.annotation.*;
import fai.comm.util.*;

import java.io.IOException;

public class ${className}Handler extends FaiHandler {

    public ${className}Handler(FaiServer server) {
        super(server);
        m_config = server.getConfig();
        if (m_config == null) {
            Log.logErr("Config null err");
            return;
        }
        
        ${className}Svr.SvrOption svrOption = m_config.getConfigObject(${className}Svr.SvrOption.class);
        if (svrOption == null) {
            Log.logErr("svrOption null err");
            return;
        }
    
        // 获取锁信息
        PosReadWriteLock lock = new PosReadWriteLock(svrOption.getLockLength());
        
        // 获取缓存信息
        ServerConfig.RedisOption cacheOption = m_config.getRedis();
        if (cacheOption == null) {
            Log.logErr("get redis option err");
            return;
        }
        Param cacheInfo = cacheOption.getRedisOption();
        RedisClientConfig redisConfig = new RedisClientConfig(cacheInfo);
        JedisPool jedisPool = JedisPoolFactory.createJedisPool(redisConfig);
        m_rdsCache = new RedisCacheManager(jedisPool, redisConfig.getExpire(), redisConfig.getExpireRandom());
        
        // 获取db信息
        ServerConfig.DaoOption daoOption = m_config.getDaopool();
        Param daoInfo = daoOption.getDaoPoolOption();
        if (daoInfo == null || daoInfo.isEmpty()) {
            Log.logErr("get daoInfo err");
            return;
        }
        DaoPool daoPool = new DaoPool(m_config.getName(), daoInfo);

        // 生成proc
        m_${className}Proc = new ${className}Proc(daoPool, m_rdsCache, lock);
    }
    
    @Cmd(${className}Def.Protocol.Cmd.ADD)
    @WrittenCmd
    public int add${className}(final FaiSession session) throws IOException {
        return m_${className}Proc.processAdd(session);
    }

    @Cmd(${className}Def.Protocol.Cmd.SET)
    @WrittenCmd
    public int set${className}(final FaiSession session) throws IOException {
        return m_${className}Proc.processSet(session);
    }
    
    @Cmd(${className}Def.Protocol.Cmd.GET)
    public int get${className}(final FaiSession session) throws IOException {
        return m_${className}Proc.processGet(session);
    }
    
    @Cmd(${className}Def.Protocol.Cmd.GET_LIST)
    public int get${className}List(final FaiSession session) throws IOException {
        return m_${className}Proc.processGetList(session);
    }

    private ${className}Proc m_${className}Proc;
    private ServerConfig m_config;
    private RedisCacheManager m_rdsCache;
}
