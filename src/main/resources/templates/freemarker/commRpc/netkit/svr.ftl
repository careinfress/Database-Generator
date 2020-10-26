${gen.setType("svr")}
package ${entity.packages.svr};

import fai.comm.cache.redis.RedisCacheManager;
import fai.comm.cache.redis.config.RedisClientConfig;
import fai.comm.cache.redis.pool.JedisPoolFactory;
import fai.comm.cache.redis.pool.JedisPool;
import fai.comm.netkit.IoSession;
import fai.comm.netkit.FaiProtocol;
import fai.comm.netkit.FaiServer;
import fai.comm.netkit.ServerConfig;
import fai.app.*;
import fai.comm.util.*;

/**
 *
 * @author ${developer.author}
 * @date ${date.toString("yyyy-MM-dd HH:mm:ss")}
 */
public class ${entity.name.svr} extends FaiServer {

    public void run(String[] args) {
        ServerConfig cfg = parseConfigFile(args);
        if (cfg == null) {
            return;
        }

        // 开启 Log 组件跟 Oss 告警组件
        openLog(cfg);
        openOss(cfg);

        // 获取 svr 配置信息
        Param option = cfg.getSvrOption();
        FaiList<String> keyList = new FaiList<String>();
        if (!cfg.checkOption(option, keyList)) {
            return;
        }
        // 获取数据库配置
        DaoPool daoPool = new DaoPool(cfg.getName(), cfg.getDaoPoolOption());
        // 获取读写锁（ReentrantReadWriteLock）生成个数
        PosReadWriteLock lock = new PosReadWriteLock(cfg.getLockLength());
        // 获取分布式缓存配置
        Param redisOption = cfg.getOption().getParam(RedisClientConfig.KEY);
        if (redisOption == null) {
            Log.logErr("redis config file not exists");
            return;
        }
        RedisClientConfig config = new RedisClientConfig(redisOption);
        if (!config.isValiad()) {
            Oss.logAlarm("redis client config invalid");
            return;
        }
        JedisPool jedisPool = JedisPoolFactory.createJedisPool(config);
        m_cache = new RedisCacheManager(jedisPool, config.getExpire(), config.getExpireRandom());

        m_${entity.name.proc.firstLower} = new ${entity.name.proc}(daoPool, m_cache, lock, option);

        addWrittenCmd(${entity.name.def}.Protocol.Cmd.ADD);
        addWrittenCmd(${entity.name.def}.Protocol.Cmd.SET);
        addWrittenCmd(${entity.name.def}.Protocol.Cmd.DEL);

        super.run(cfg);
    }

    @Override
    public int processThread(IoSession session, FaiProtocol recvProtocol, FaiProtocol sendProtocol) {
        int cmd = recvProtocol.getCmd();
        switch (cmd) {
        case ${entity.name.def}.Protocol.Cmd.ADD:
            return m_${entity.name.proc.firstLower}.processAdd(recvProtocol, sendProtocol);
        case ${entity.name.def}.Protocol.Cmd.SET:
            return m_${entity.name.proc.firstLower}.processSet(recvProtocol, sendProtocol);
        case ${entity.name.def}.Protocol.Cmd.DEL:
            return m_${entity.name.proc.firstLower}.processDel(recvProtocol, sendProtocol);
        case ${entity.name.def}.Protocol.Cmd.GET:
            return m_${entity.name.proc.firstLower}.processGet(recvProtocol, sendProtocol);
        case ${entity.name.def}.Protocol.Cmd.GET_LIST:
            return m_${entity.name.proc.firstLower}.processGetLit(recvProtocol, sendProtocol);

        default:
            int rt = Errno.ARGS_ERROR;
            Log.logErr(rt, "unknown cmd;cmd=" + cmd);
            return rt;
        }
    }


    private RedisCacheManager m_cache;
    private ${entity.name.proc} m_${entity.name.proc.firstLower};

    public static void main(String[] args) {
        ${entity.name.svr} svr = new ${entity.name.svr}();
        svr.run(args);
    }


}