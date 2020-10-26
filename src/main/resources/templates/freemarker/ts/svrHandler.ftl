${gen.setType("handler")}
package ${entity.packages.svr};

import fai.app.*;
import fai.comm.cache.redis.RedisCacheManager;
import fai.comm.cache.redis.config.RedisClientConfig;
import fai.comm.cache.redis.pool.JedisPool;
import fai.comm.cache.redis.pool.JedisPoolFactory;
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
public class ${entity.name.handler} extends FaiHandler {

    public ${entity.name.handler}(FaiServer server) {
        super(server);
        m_config = server.getConfig();
        if (m_config == null) {
            Log.logErr("Config null err");
            return;
        }

        ${entity.name.svr}.SvrOption svrOption = m_config.getConfigObject(${entity.name.svr}.SvrOption.class);
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
        m_${entity.name.firstLower}Proc = new ${entity.name.proc}(daoPool, m_rdsCache, lock);
    }
    
    @Cmd(${entity.name.def}.Protocol.Cmd.ADD)
    @WrittenCmd
    public int add${entity.name}(final FaiSession session) throws IOException {
        return m_${entity.name.firstLower}Proc.processAdd(session);
    }

    @Cmd(${entity.name.def}.Protocol.Cmd.SET)
    @WrittenCmd
    public int set${entity.name}(final FaiSession session) throws IOException {
        return m_${entity.name.firstLower}Proc.processSet(session);
    }
    
    @Cmd(${entity.name.def}.Protocol.Cmd.GET)
    public int get${entity.name}(final FaiSession session) throws IOException {
        return m_${entity.name.firstLower}Proc.processGet(session);
    }
    
    @Cmd(${entity.name.def}.Protocol.Cmd.GET_LIST)
    public int get${entity.name}List(final FaiSession session) throws IOException {
        return m_${entity.name.firstLower}Proc.processGetList(session);
    }

    private ${entity.name.proc} m_${entity.name.firstLower}Proc;
    private ServerConfig m_config;
    private RedisCacheManager m_rdsCache;
}
