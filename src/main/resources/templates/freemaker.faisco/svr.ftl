package fai.svr.${className}Svr;

import fai.comm.jnetkit.config.ParamKeyMapping;
import fai.comm.jnetkit.server.ServerConfig;
import fai.comm.jnetkit.server.fai.FaiServer;

public class ${className}Svr {

    public static void main(String[] args) throws Exception {
        ServerConfig config = new ServerConfig(args);
        FaiServer server = new FaiServer(config);
        server.setHandler(new ${className}Handler(server));
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