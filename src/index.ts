import 'reflect-metadata';
import 'dotenv-safe/config';
import { PrismaClient } from '@prisma/client';
import { ApolloServer } from 'apollo-server-express';
import ConnectRedis from 'connect-redis';
import cors from 'cors';
import express from 'express';
import session from 'express-session';
// import { join } from 'path';
import { buildSchema } from 'type-graphql';
import { Context } from './@types/context';
import { FRONTEND_URL, PORT, REDIS_PREFIX_COOKIE_SESSION, SESSION_ID, SESSION_SECRET, __PROD__ } from './constants';
import { resolvers } from '@generated/type-graphql';
import { RedisClient } from './redisConfig';
import { authChecker } from './utils/authChecker';

const prisma = new PrismaClient({ errorFormat: 'pretty', log: ['query'] });

const main = async () => {
	// ============================================================
	// 			SETUP EXPRESS APP
	// ============================================================
	const app = express();
	app.set('trust proxy', 1);
	app.use(cors({ credentials: true, origin: FRONTEND_URL }));

	// ============================================================
	// 			INSTANTIATE REDIS CONNECTION AND SESSIONS
	// ============================================================
	const RedisStore = ConnectRedis(session);
	app.use(
		session({
			store: new RedisStore({
				client: RedisClient,
				prefix: REDIS_PREFIX_COOKIE_SESSION,
				disableTouch: true,
			}),
			name: SESSION_ID,
			secret: SESSION_SECRET,
			proxy: true,
			resave: false,
			saveUninitialized: false,
			cookie: {
				httpOnly: true,
				sameSite: 'lax',
				secure: __PROD__,
				maxAge: 1000 * 60 * 60 * 24 * 365, //1 YEAR
			},
		})
	);

	// ============================================================
	// 			CONNECT PRISMA TO DATABASE
	// ============================================================
	try {
		await prisma.$connect();
		console.log('Prisma Connected!');
	} catch (e) {
		console.warn('Prisma Connection Error');
		console.log(e);
		process.exit(1);
	}

	// ============================================================
	// 			GENERATE GRAPHQL SCHEMA
	// ============================================================
	const schema = await buildSchema({
		resolvers: [...resolvers], //join(__dirname, './modules/**/Resolver.*js'),
		emitSchemaFile: {
			path: './schema.gql',
			commentDescriptions: true,
			sortedSchema: true,
		},
		authChecker,
	});

	// ============================================================
	// 			GENERATE THE GRAPHQL SERVER
	// ============================================================
	const server = new ApolloServer({
		schema,
		context: ({ req, res }): Context => {
			const requestId = String(Math.floor(Math.random() * Number.MAX_SAFE_INTEGER));
			return {
				req,
				res,
				prisma,
				requestId,
				redis: RedisClient,
				session: req.session,
			};
		},
		tracing: !__PROD__,
		playground: __PROD__
			? false
			: {
					settings: {
						'request.credentials': 'include',
					},
			  },
	});
	server.applyMiddleware({ app: app, cors: false });

	// ============================================================
	// 			START THE SERVER
	// ============================================================
	app.listen(PORT, () => {
		console.log('🚀 Server is running');
		if (!__PROD__) {
			console.log(`🚀 GraphQL Playground available at http://localhost:${PORT}${server.graphqlPath}`);
		}
	});
};

main()
	.catch((e) => {
		console.error(e);
	})
	.finally(() => {
		prisma.$disconnect();
	});
