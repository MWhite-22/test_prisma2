export default 'placeholder';

// import DataLoader from 'dataloader';
// import { ClassType } from 'type-graphql';

// interface entityMap {
// 	Book: Book;
// 	BookChapter: BookChapter;
// 	User: User;
// }

// export type createEntityLoaders = { [P in keyof entityMap]: DataLoader<string, entityMap[P], string> };

// interface cdlOptions<T extends CoreEntity> {
// 	array?: boolean;
// 	where?: ExtractPrimitiveFieldNames<T>;
// }

// const createLoader = <T extends CoreEntity>(entity: ClassType<T>, userOptions?: cdlOptions<T>) => {
// 	const defaultOptions: cdlOptions<CoreEntity> = {
// 		array: undefined,
// 		where: 'id',
// 	};

// 	const options = {
// 		...defaultOptions,
// 		...userOptions,
// 	};

// 	return new DataLoader<string, T>(async (ids) => {
// 		const entities = await getManager().find(entity, { where: { [`${options.where}`]: In(ids as string[]) } });
// 		const idToEntityMap: Record<string, T> = {};
// 		entities.forEach((e) => {
// 			idToEntityMap[e.id] = e;
// 		});
// 		return ids.map((id) => idToEntityMap[id]);
// 	});
// };

// export function createEntityLoaders(): createEntityLoaders {
// 	return {
// 		Book: createLoader(Book),
// 		BookChapter: createLoader(BookChapter, { where: 'bookId' }),
// 		User: createLoader(User),
// 	};
// }
