${gen.setType("svr")}
package ${entity.packages.svr};

import fai.comm.jnetkit.config.ParamKeyMapping;
import fai.comm.jnetkit.server.ServerConfig;
import fai.comm.jnetkit.server.fai.FaiServer;

/**
 *
 * @author ${developer.author}
 * @date ${date.toString("yyyy-MM-dd HH:mm:ss")}
 */
public class ${entity.name.svr} {

    public static void main(String[] args) throws Exception {
        ServerConfig config = new ServerConfig(args);
        FaiServer server = new FaiServer(config);
        server.setHandler(new ${entity.name.handler}(server));
        server.start();
    }


    @ParamKeyMapping(path = ".svr")
    public static class SvrOption {
        private int lockLength;
        public int getLockLength() {
            return lockLength;
        }
        public void setLockLength(int lockLength) {
            this.lockLength = lockLength;
        }
    }


}